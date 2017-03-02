defmodule Whale2.Router do
  use Whale2.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Whale2 do
    pipe_through :api
  end
end
