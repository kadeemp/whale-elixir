defmodule Whale2.Like do
  use Whale2.Web, :model

  schema "likes" do
    belongs_to :answer, Whale2.Answer
    belongs_to :user, Whale2.User

    timestamps()
  end

    @allowed_fields ~w(answer_id user_id)a
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
