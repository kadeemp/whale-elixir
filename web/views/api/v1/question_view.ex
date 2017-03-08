defmodule Whale2.Api.V1.QuestionView do
  use Whale2.Web, :view

  def render("index.json", %{questions: questions}) do
    %{
      page: questions.page,
      per_page: questions.per_page,
      total_pages: questions.total_pages,
      data: render_many(questions.entries, __MODULE__, "question.json")
    }
  end

  def render("show.json", %{question: question}) do
    render_one(question, __MODULE__, "question.json")
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      content: question.content,
      sender: render(Whale2.Api.V1.UserView, "detail.json", user: question.sender),
      reciever: render(Whale2.Api.V1.UserView, "detail.json", user: question.receiver)
    }
  end
end
