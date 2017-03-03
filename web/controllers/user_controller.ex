defmodule Whale2.Api.V1.UserController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.UserView
  require IEx

  def index(conn, _params) do
    users = Repo.all(User)
    user = List.first(users)

#    render(conn, "index.json", users: users)

  end
    
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    followers = Repo.all assoc(user, :followers)
#    follower_count =
#    IEx.pry
    conn
    |> render("show.json", user: user, followers: followers)
  end

  def create(conn, params) do
    # changeset = User.registration_changeset(%User{}, user_params)
    # case Repo.insert(changeset) do
    #   {:ok, user} ->
    #     conn
    #     |> Rumbl.Auth.login(user)
    #     |> put_flash(:info, "#{user.name} created!")
    #     |> redirect(to: user_path(conn, :index))
    #   {:error, changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end

    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Whale2.Auth.login(user)
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, _changeset} ->
        send_resp(conn, 422, "")
    end
  end
end
