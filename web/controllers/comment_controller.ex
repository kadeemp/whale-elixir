defmodule Whale2.Api.V1.CommentController do
  use Whale2.Web, :controller
  alias Whale2.Comment

  # Fetches all comments for a given question
  def index(conn, _params = %{"answer_id" => answer_id}) do
    query = from c in Comment, where: c.answer_id == ^answer_id
    comments = Repo.all(query)
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    changeset = Comment.changeset(%Comment{}, comment_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> render("show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    send_resp(conn, :no_content, "")
  end
end
