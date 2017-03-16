defmodule Whale2.Question do
  use Whale2.Web, :model
  alias Whale2.{User, Answer}

  schema "questions" do
    field :content, :string
    field :categories, {:array, :string}
    belongs_to :sender, User, foreign_key: :sender_id
    belongs_to :receiver, User, foreign_key: :receiver_id
    has_one :answer, Answer

    timestamps()
  end

  @allowed_fields ~w(content)
  @required_fields ~w(content)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def order_by_inserted_at(query) do
    from question in query,
    order_by: [desc: question.inserted_at]
  end

  def preload_users(query) do
    query
        |> join(:left, [question], sender in assoc(question, :sender))
        |> join(:left, [question], receiver in assoc(question, :receiver))
        |> preload([question, sender, receiver], [sender: sender, receiver: receiver])
  end

  def unanswered_questions(query) do
    from q in query,
        left_join: a in assoc(q, :answer),
        where: is_nil(a.id)
  end
end
