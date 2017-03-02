defmodule Whale2.Router do
  use Whale2.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :authorized do
    plug Guardian.Plug.EnsureAuthenticated, handler: Whale2.AuthHandler
  end

  scope "/api/v1", Whale2 do
    pipe_through :api

    scope "/" do
      pipe_through :authorized

    end
  end
end
