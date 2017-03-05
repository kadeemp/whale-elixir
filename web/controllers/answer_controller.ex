defmodule Whale2.Api.V1.AnswerController do
    use Whale2.Web, :controller
    alias Whale2.Api.V1.AnswerView
    alias Whale2.Answer

    def index(conn, %{"page_size" => page_size, "offset" => offset}) do
        query = from a in Answer
        answers = Repo.all(query)
        conn
            |> render("index.json", answers: answers)
    end

    def create(conn, params) do
        changeset = Answer.changeset(%Answer{}, params)

        case Repo.insert(changeset) do
            {:ok, answer} ->
                conn
                |> put_status(:created)
                |> render("show.json", answer: answer)
            {:error, _changeset} ->
                send_resp(conn, 422, "")
        end
    end
end