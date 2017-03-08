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
  question_query = from q in Question,
                    where: q.id == ^question_id

    question = question_query
                |> Question.preload_users
                |> Repo.one

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
      {:error, changeset} ->
      conn
         |> put_status(:created)
         |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
