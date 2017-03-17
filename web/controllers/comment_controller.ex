defmodule Whale2.Api.V1.CommentController do
  use Whale2.Web, :controller
  alias Whale2.{Comment, Paginator, Answer}
  require IEx

  # Fetches all comments for a given question
  def index(conn, params = %{"answer_id" => answer_id}, _user) do
    comments = Comment
        |> Comment.by_answer(answer_id)
        |> Comment.preload_user
        |> Comment.order_by_inserted_at
        |> Paginator.new(params)

    conn
      |> render("index.json", comments: comments)
  end

  def create(conn, %{"answer_id" => answer_id, "comment" => comment}, user) do
    answer = Repo.get!(Answer, answer_id)

    comment_params = %{answer_id: answer_id, content: comment, commenter_id: user.id}

    changeset =
      Comment.changeset(%Comment{}, comment_params)
      |> put_assoc(:commenter, user)
      |> put_assoc(:answer, answer)

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

  def update(conn, %{"id" => id, "comment" => comment_params}, user) do
    changeset =
      user
      |> user_comments
      |> Repo.get!(id)
      |> Comment.changeset(comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Whale2.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    user
    |> user_comments
    |> Repo.get!(id)
    |> Repo.delete!

    send_resp(conn, :no_content, "")
  end

  defp user_comments(user) do
    assoc(user, :comments)
  end

  def action(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)

    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
  end
end
