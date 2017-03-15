defmodule Whale2.Answer do
  use Whale2.Web, :model
  use Arc.Ecto.Schema
  alias Whale2.{Like, Comment}

  schema "answers" do
    field :thumbnail, Whale2.Uploaders.AnswerThumbnailUploader.Type
    field :video, Whale2.Uploaders.AnswerVideoUploader.Type
    belongs_to :question, Whale2.Question
    has_many :comments, Whale2.Comment
    has_many :likes, Whale2.Like

    timestamps()
  end

    @allowed_fields ~w(question_id)a
    @required_fields @allowed_fields
    @attachment_fields ~w(video thumbnail)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> cast_assoc(:question)
    |> validate_required(@required_fields)
    |> unique_constraint(:question_id)
    |> cast_attachments(params, @attachment_fields, @attachment_fields)
  end

  def order_by_inserted_at(query) do
      from answer in query,
      order_by: [desc: answer.inserted_at]
  end
  
  def preload_question_and_users(query) do
    from a in query,
      left_join: q in assoc(a, :question),
      left_join: sender in assoc(q, :sender),
      left_join: receiver in assoc(q, :receiver),
      preload: [question: {q, sender: sender, receiver: receiver}]
  end

  def likes_and_comments_count(query) do
    likes = from l in Like,
      select: %{answer_id: l.answer_id, like_count: count(l.id)},
      group_by: l.answer_id

    comments = from c in Comment,
      select: %{answer_id: c.answer_id, comment_count: count(c.id)},
      group_by: c.answer_id

    from a in query,
      left_join: l in subquery(likes), on: a.id == l.answer_id,
      left_join: c in subquery(comments), on: a.id == c.answer_id,
      select: {a, l.like_count, c.comment_count}
  end
end
