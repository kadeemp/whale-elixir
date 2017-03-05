defmodule Whale2.User do
    use Whale2.Web, :model
    use Arc.Ecto.Schema
    alias Whale2.Relationship
    require IEx

    schema "users" do
        field :first_name, :string
        field :last_name, :string
        field :username, :string
        field :email, :string
        field :image_url, Whale2.Uploaders.UserImage.Type

        # Active Relationships
        # When userA follows userB, userA has an active relationship with userB
        has_many :active_relationships, Relationship, foreign_key: :follower_id
        has_many :following, through: [:active_relationships, :followed]

        # Passive Relationships
        # When userA follows userB, userB has a passive relationship with userA
        has_many :passive_relationships, Relationship, foreign_key: :followed_id
        has_many :followers, through: [:passive_relationships, :follower]

        has_many :sent_questions, Whale2.User
        has_many :received_questions, Whale2.User

        timestamps()
    end

    @allowed_fields ~w(first_name last_name email username)
    @required_fields ~w(first_name last_name email username)a
    @email_regex ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/i

    def changeset(model, params \\ %{}) do
      model
      |> cast(params, @allowed_fields)
      |> validate_required(@required_fields)
      |> validate_format(:email, @email_regex)
      |> unique_constraint(:email)
      |> cast_attachments(params, [:image_url])
    end

    def update_changeset(model, params \\ %{})  do
      model
      |> cast_attachments(params, [:image_url])
    end
end
