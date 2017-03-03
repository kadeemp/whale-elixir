defmodule Whale2.User do
    use Whale2.Web, :model
    use Arc.Ecto.Schema
    alias Whale2.Relationship

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

        timestamps()
    end

    @required_fields ~w(name email password)a
    @allowed_fields ~w(name email password image)
    @email_regex ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/i

    def changeset(model, params \\ %{}) do
          model
          |> cast(params, @allowed_fields)
          |> validate_required(@required_fields)
          |> validate_format(:email, @email_regex)
          |> unique_constraint(:email)
    end

    def update_changeset(model, params \\ %{})  do
        model
            |> cast_attachments(params, [:image_url])
    end
end
