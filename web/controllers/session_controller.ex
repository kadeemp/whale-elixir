defmodule Whale2.Api.V1.SessionController do
  use Whale2.Web, :controller
    require IEx
  alias Whale2.{Api.V1.UserView, Auth, User}

  def create(conn, %{"username" => username, "password" => password}) do
    case Auth.authenticate_user(username, password) do
      {:ok, user} ->
        # user followers/following count will be nil

        conn
        |> Whale2.Auth.login(user)
        |> put_status(:ok)
        |> render(UserView, "show.json", user: user)
      {:unauthorized, _} ->
        send_resp(conn, :unauthorized, "")
      {:not_found, _} ->
        send_resp(conn, :unauthorized, "")
    end
  end
  
  def show(conn, _params) do
    user = conn.assigns.current_user
    IEx.pry
    user = user
        |> User.count_followers
        |> User.count_following

    conn
        |> render(UserView, "show.json", user: user)
  end
end
