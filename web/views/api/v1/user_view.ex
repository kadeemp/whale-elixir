defmodule Whale2.Api.V1.UserView do
    use Whale2.Web, :view
    require IEx

    def render("index.json", %{users: users}) do
      render_many(users, __MODULE__, "user.json")
    end

    def render("show.json", params = %{user: user}) do
      render_one(user, __MODULE__, "user.json")
    end
    def render("show.json", params = %{user: user, followers: followers}) do
      render_one(params, __MODULE__, "user.json")
    end

    def render("user.json", params) do
      user = params.user.user
      followers = params.user.followers

      %{id: user.id,
        name: user.first_name <> " " <> user.last_name,
        username: user.username,
        image_url: Whale2.Uploaders.UserImage.url({user.image_url, user}, :thumb),
        email: user.email,
        followers: render_many(followers, __MODULE__, "relationship.json")
      }
    end
    
    def render("relationship.json", relationship) do
      %{id: relationship.user.id,
        username: relationship.user.username,
        email: relationship.user.email,
        image_url: Whale2.Uploaders.UserImage.url({relationship.user.image_url, relationship.user}, :thumb)
      }
    end
end
