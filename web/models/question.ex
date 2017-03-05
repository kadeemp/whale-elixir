defmodule Whale2.Question do
  use Whale2.Web, :model

  schema "questions" do
    field :content, :string
    field :categories, {:array, :string}
    belongs_to :sender, Whale2.User
    belongs_to :receiver, Whale2.User

    timestamps()
  end

  @required_fields ~w(content sender_id receiver_id)a
  @allowed_fields ~w(content sender_id receiver_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end
end
