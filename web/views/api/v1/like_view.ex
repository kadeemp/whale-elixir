defmodule Whale2.Api.V1.LikeView do
    use Whale2.Web, :view

    def render("index.json", %{likes: likes}) do
      %{  page: likes.page,
          per_page: likes.per_page,
          total_pages: likes.total_pages,
          data: render_many(likes.entries, __MODULE__, "like.json")
      }
    end

    def render("show.json", %{like: like}) do
      render_one(like, __MODULE__, "like.json")
    end

    def render("like.json", %{like: like}) do
        %{id: like.id,
          user_id: like.user_id,
          answer_id: like.answer_id,
          user: render(Whale2.Api.V1.UserView, "show.json", user: like.user)
          }
    end
end
