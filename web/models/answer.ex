defmodule Whale2.Answer do
  use Whale2.Web, :model

  schema "answers" do
    field :video_url, :string
    field :thumbnail_url, :string
    belongs_to :question, Whale2.Question

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:video_url, :thumbnail_url])
    |> validate_required([:video_url, :thumbnail_url])
  end
end
