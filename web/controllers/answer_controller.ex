defmodule Whale2.Api.V1.AnswerController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.AnswerView
  alias Whale2.{Answer, Paginator, Question, EmptyView}
  require IEx

  def index(conn, params) do
    answers =
      Answer
      |> Answer.order_by_inserted_at
      |> Answer.preload_question_and_users
      |> Answer.likes_and_comments_count
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

    with true <- user.id == question.receiver_id do

        # Try uploading the answer payload, we don't care about failure now 
        upload_task = Task.async(fn ->
            changeset = Answer.changeset(%Answer{}, params)
            Repo.insert(changeset)
        end)

        conn
            |> put_status(:created)
            |> render(EmptyView, "empty.json")

      else false ->
        send_resp(conn, :unprocessable_entity, "")
    end

  end

end
