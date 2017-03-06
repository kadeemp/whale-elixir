defmodule Whale2.Api.V1.UserView do
    use Whale2.Web, :view
    require IEx

    def render("index.json", %{users: users}) do
        %{  page: users.page,
            per_page: users.per_page,
            total_pages: users.total_pages,
            data: render_many(users.entries, __MODULE__, "user.json")
        }
    end

    def render("show.json", %{user: user}) do
      render_one(user, __MODULE__, "user.json")
    end

    def render("user.json", %{user: user}) do
      %{  id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          username: user.username,
          image_url: Whale2.Uploaders.UserImage.url({user.image_url, user}, :thumb),
          email: user.email,
          follower_count: user.followers_count,
          following_count: user.following_count
      }
    end
end
