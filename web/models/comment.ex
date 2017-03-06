defmodule Whale2.Comment do
  use Whale2.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :commenter, Whale2.User
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

    def order_by_inserted_at(query) do
        from comment in query,
            order_by: [desc: comment.inserted_at]
    end

    def by_answer(query, answer_id) do
        from c in query,
            where: c.answer_id == ^answer_id
    end
end
