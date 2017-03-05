defmodule Whale2.Api.V1.QuestionController do
  use Whale2.Web, :controller
  alias Whale2.Question
  alias Whale2.Api.V1.QuestionView
  alias Ecto.Changeset

  def create(conn = %{assigns: %{current_user: sender}}, params = %{"receiver_id" => receiver_id}) do
    receiver = Repo.get!(User, receiver_id)

    %Question{}
    |> Question.changeset(params)
    |> Changeset.put_assoc(:sender, sender)
    |> Changeset.put_assoc(:receiver, receiver)
    |> Repo.insert
    |> case do
         {:ok, question} ->
           conn
           |> put_status(:created)
           |> render("show.json", question: question)
         {:error, _changeset} ->
           send_resp(conn, 422, "")
       end
  end
end
