defmodule Whale2.Api.V1.LikeView do
  use Whale2.Web, :view

  def render("index.json", %{likes: likes}) do
    %{data: render_many(likes, __MODULE__, "like.json")}
  end

  def render("show.json", %{like: like}) do
    %{data: render_one(like, __MODULE__, "like.json")}
  end

  def render("like.json", %{like: like}) do
    %{id: like.id,
      user_id: like.user_id,
      answer_id: like.answer_id}
  end
end
