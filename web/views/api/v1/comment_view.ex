defmodule Whale2.Api.V1.CommentView do
  use Whale2.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, __MODULE__, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, __MODULE__, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      commenter_id: comment.commenter_id,
      content: comment.content,
      answer_id: comment.answer_id}
  end
end
