defmodule Whale2.Api.V1.UserController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.UserView
  require IEx

  def index(conn, _params) do
  end
    
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    followers = assoc(user, :followers)
    followers_count = get_association(followers)

    following = assoc(user, :following)
    following_count = get_association(following)

    conn
    |> render("show.json", user: user, follower_count: followers_count, following_count: following_count)
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Whale2.Auth.login(user)
        |> put_status(:created)
        # TODO: remove hard coded follower/following count
        |> render("show.json", user: user, follower_count: 0, following_count: 0)
      {:error, _changeset} ->
        send_resp(conn, 422, "")
    end
  end

  def get_association(assoc) do
    Repo.one(from u in assoc, select: count(u.id))
  end
end
