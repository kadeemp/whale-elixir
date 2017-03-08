defmodule Whale2.Api.V1.QuestionController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.QuestionView
  alias Whale2.{Question, Paginator}

  def index(conn, params) do
    questions = Question
        |> Question.order_by_inserted_at
        |> Question.preload_users
        |> Paginator.new(params)

    conn
        |> render("index.json", questions: questions)

  end
  def show(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    render(conn, "show.json", question: question)
  end

  def create(conn = %{assigns: %{current_user: sender}}, params = %{"receiver_id" => receiver_id}) do
    receiver = Repo.get!(User, receiver_id)

    %Question{}
    |> Question.changeset(params)
    |> put_assoc(:sender, sender)
    |> put_assoc(:receiver, receiver)
    |> Repo.insert
    |> case do
         {:ok, question} ->
           conn
           |> put_status(:created)
           |> render("show.json", question: question)
         {:error, _changeset} ->
           send_resp(conn, :unprocessable_entity, "")
       end
  end
end
