defmodule Whale2.Api.V1.LikeController do
    use Whale2.Web, :controller
    alias Whale2.{Paginator, Like}

  # Gets all users who like an answer
  def index(conn, params = %{"answer_id" => answer_id}) do
    likes = Like
        |> Like.by_answer(answer_id)
        |> Like.preload_users
        |> Like.order_by_inserted_at
        |> Paginator.new(params)

    render(conn, "index.json", likes: likes)
  end

  def create(conn, %{"like" => like_params}) do
    changeset = Like.changeset(%Like{}, like_params)

    case Repo.insert(changeset) do
      {:ok, like} ->
        conn
        |> put_status(:created)
        |> render("show.json", like: like)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    like = Repo.get!(Like, id)
    render(conn, "show.json", like: like)
  end

  def update(conn, %{"id" => id, "like" => like_params}) do
    like = Repo.get!(Like, id)
    changeset = Like.changeset(like, like_params)

    case Repo.update(changeset) do
      {:ok, like} ->
        render(conn, "show.json", like: like)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    like = Repo.get!(Like, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(like)

    send_resp(conn, :no_content, "")
  end
end
