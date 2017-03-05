defmodule Whale2.Api.V1.QuestionView do
  use Whale2.Web, :view

  def render("show.json", %{question: question}) do
    render_one(question, Whale2.Api.V1.QuestionView, "question.json")
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      content: question.content
    }
  end
end
