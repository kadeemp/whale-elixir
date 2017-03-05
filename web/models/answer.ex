defmodule Whale2.Answer do
  use Whale2.Web, :model
  use Arc.Ecto.Schema

  schema "answers" do
    field :thumbnail, Whale2.Uploaders.AnswerThumbnailUploader.Type
    field :video, Whale2.Uploaders.AnswerVideoUploader.Type
    belongs_to :question, Whale2.Question
    has_many :comments, Whale2.Comment

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
    |> cast_attachments(params, @attachment_fields, @attachment_fields)
  end
end
