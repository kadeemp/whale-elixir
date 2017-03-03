defmodule Whale2.AuthHandler do
  use Whale2.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> send_resp(401, "")
    |> halt()
  end

  def unauthorized(conn, _params) do
    conn
    |> send_resp(401, "")
    |> halt()
  end
end
