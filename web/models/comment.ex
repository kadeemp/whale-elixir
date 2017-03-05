defmodule Whale2.Comment do
  use Whale2.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :commenter, Whale2.Commenter
    belongs_to :answer, Whale2.Answer

    timestamps()
  end

    @allowed_fields ~w(content answer_id commenter_id)a
    @required_fields @allowed_fields

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end
end
