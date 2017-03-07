defmodule Whale2.Auth do
  import Plug.Conn
  import Ecto.Query
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, current_user)
  end

  def authenticate_user(username, password) do
    user = Whale2.Repo.get_by(Whale2.User, username: username)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:unauthorized, nil}
      true ->
        dummy_checkpw()
        {:not_found, nil}
    end
  end

  def login(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    {:ok, claims} = Guardian.Plug.claims(new_conn)
    exp = Map.get(claims, "exp")

    new_conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", Integer.to_string(exp)) 
  end
end
