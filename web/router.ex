defmodule Whale2.Router do
  use Whale2.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Whale2.Auth
  end

  pipeline :authorized do
    plug Guardian.Plug.EnsureAuthenticated, handler: Whale2.AuthHandler
  end

  scope "/api/v1", Whale2.Api.V1 do
    pipe_through :api

    get "/users/newbies", UserController, :newbies
    resources "/users", UserController
    post "/sessions", SessionController, :create

    scope "/" do
        pipe_through :authorized

        get "/sessions", SessionController, :show

        resources "/questions", QuestionController, only: [:create, :show, :index] do
          post "/answers", AnswerController, :create
        end

        resources "/comments", CommentController, only: [:update, :delete]

        resources "/answers", AnswerController, only: [:index] do
          resources "/comments", CommentController, only: [:index, :create]
          resources "/likes", LikeController, only: [:index, :create]
        end
    end
  end
end
