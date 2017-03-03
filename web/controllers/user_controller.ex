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

  def create(conn, _params) do

  end
end
