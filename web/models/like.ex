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

    def order_by_inserted_at(query) do
        from like in query,
        order_by: [desc: like.inserted_at]
    end

    def preload_users(query) do
      from user in query,
          preload: :user
    end

    def by_answer(query, answer_id) do
        from c in query,
            where: c.answer_id == ^answer_id
    end
end
