defmodule Whale2.Api.V1.UserController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.UserView
  require IEx

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user =
      Repo.get!(User, id)
      |> count_followers
      |> count_following

    render(conn, "show.json", user: user)
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Whale2.Auth.login(user)
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, _changeset} ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end

  defp count_followers(user) do
    followers_count =
      followers_query(user)
      |> Repo.aggregate(:count, :id)

    %User{user | followers_count: followers_count}
  end

  defp count_following(user) do
    following_count =
      following_query(user)
      |> Repo.aggregate(:count, :id)

    %User{user | following_count: following_count}
  end

  defp followers_query(user), do: assoc(user, :followers)
  defp following_query(user), do: assoc(user, :following)
end
