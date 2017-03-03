defmodule Whale2.Api.V1.UserView do
    use Whale2.Web, :view
    require IEx

    def render("index.json", %{users: users}) do
      render_many(users, __MODULE__, "user.json")
    end

    def render("show.json", params = %{user: user, follower_count: follower_count, following_count: following_count}) do
        %{  id: user.id,
            name: user.first_name <> " " <> user.last_name,
            username: user.username,
            image_url: Whale2.Uploaders.UserImage.url({user.image_url, user}, :thumb),
            email: user.email,
            follower_count: follower_count,
            following_count: following_count
        }
    end
end