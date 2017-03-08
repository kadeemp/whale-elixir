defmodule Whale2.Api.V1.AnswerController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.AnswerView
  alias Whale2.{Answer, Like, Paginator}
  require IEx

  def index(conn, params) do
    answers = Answer
        |> Answer.order_by_inserted_at
        |> Answer.preload_question_and_users
        |> Paginator.new(params)

    conn
        |> render("index.json", answers: answers)
  end

  def create(conn, params) do

    # TODO:
    # should we fetch from db to see whether question_id exists?
    # check if current_user can answer the given question(if current_user.id == question.receiver.id)

    changeset = Answer.changeset(%Answer{}, params)

    with {:ok, answer} <- Repo.insert(changeset) do
      answer = answer |> Answer.preload_question_and_users

      conn
      |> put_status(:created)
      |> render("show.json", answer: answer)
    else
      {:error, _changeset} -> send_resp(conn, :unprocessable_entity, "")
    end
  end

end
