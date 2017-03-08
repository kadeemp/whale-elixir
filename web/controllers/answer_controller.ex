defmodule Whale2.Api.V1.AnswerController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.AnswerView
  alias Whale2.{Answer, Like, Paginator, Question}
  require IEx

  def index(conn, params) do
    answers = Answer
        |> Answer.order_by_inserted_at
        |> Answer.preload_question_and_users
        |> Paginator.new(params)

    conn
        |> render("index.json", answers: answers)
  end

  def create(conn, %{"question_id" => question_id} = params) do
    question = Repo.get!(Question, question_id)
    |> Repo.preload([:sender, :receiver])

    user = conn.assigns.current_user

    changeset = Answer.changeset(%Answer{}, params)

    with true <- user.id == question.receiver_id,
         {:ok, answer} <- Repo.insert(changeset) do
      answer = %{answer | question: question}

        conn
        |> put_status(:created)
        |> render("show.json", answer: answer)
    else
      false -> send_resp(conn, 401, "")
      {:error, _changeset} -> send_resp(conn, :unprocessable_entity, "")
    end

    # TODO:
    # should we fetch from db to see whether question_id exists?
    # check if current_user can answer the given question(if current_user.id == question.receiver.id)


    # with {:ok, answer} <- Repo.insert(changeset) do
    #     IEx.pry
    #   answer = answer |> Repo.preload(:likes)

    # else
    # end
  end

end
