defmodule Whale2.Api.V1.UserController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.UserView
  alias Whale2.{User, Paginator}
  require IEx

  def index(conn, params) do
      users = User
          |> User.order_by_inserted_at
          |> Paginator.new(params)

      conn
          |> render("detail_index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user =
      Repo.get!(User, id)
      |> User.count_followers
      |> User.count_following

    render(conn, "show.json", user: user)
  end

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->

        user = user
            |> User.count_followers
            |> User.count_following

        conn
            |> Whale2.Auth.login(user)
            |> put_status(:created)
            |> render("show.json", user: user)
      {:error, changeset} ->

            conn
            |> put_status(:unprocessable_entity)
            |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

    def update(conn, params) do
        user = Repo.get!(User, conn.assigns.current_user.id)

        changeset = User.update_changeset(user, params)

        case Repo.update(changeset) do
          {:ok, user} ->
            render(conn, "show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
        end
    end

  def newbies(conn, params) do
    users = User
        |> User.order_by_inserted_at
        |> User.newbies
        |> Paginator.new(params)

    conn
      |> render("index.json", users: users)
  end
end
