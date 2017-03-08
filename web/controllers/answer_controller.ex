defmodule Whale2.Api.V1.AnswerController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.AnswerView
  alias Whale2.{Answer, Like, Paginator}
  require IEx

  def index(conn, params) do
    answers = Answer
        |> Answer.order_by_inserted_at
        |> join(:left, [answer], question in assoc(answer, :question))
        |> join(:left, [answer, question], sender in assoc(question, :sender))
        |> join(:left, [answer, question], receiver in assoc(question, :receiver))
        |> preload([answer, question, sender, receiver], [question: {question, sender: sender, receiver: receiver}])
        |> Paginator.new(params)

    conn
        |> render("index.json", answers: answers)
  end

  def create(conn, params) do
    # should we fetch from db to see whether question_id exists?
    changeset = Answer.changeset(%Answer{}, params)

    with {:ok, answer} <- Repo.insert(changeset) do
      answer = answer |> Repo.preload(:likes)

      conn
      |> put_status(:created)
      |> render("show.json", answer: answer)
    else
      {:error, _changeset} -> send_resp(conn, :unprocessable_entity, "")
    end
  end

end
