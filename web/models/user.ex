defmodule Whale2.User do
    use Whale2.Web, :model
    use Arc.Ecto.Schema
    alias Whale2.{Relationship, Repo}
    import Comeonin.Bcrypt

    schema "users" do
        field :first_name, :string
        field :last_name, :string
        field :username, :string
        field :email, :string
        field :password, :string, virtual: true
        field :password_hash, :string
        field :image_url, Whale2.Uploaders.UserImage.Type
        field :followers_count, :integer, virtual: true
        field :following_count, :integer, virtual: true

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
        has_many :comments, Whale2.Comment, foreign_key: :commenter_id

        timestamps()
    end

    @allowed_fields ~w(first_name last_name email username)
    @required_fields ~w(first_name last_name email username)a
    @email_regex ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/i
    @attachment_fields ~w(image_url)a

    def changeset(model, params \\ %{}) do
      model
      |> cast(params, @allowed_fields)
      |> validate_required(@required_fields)
      |> validate_format(:email, @email_regex)
      |> unique_constraint(:email)
      |> unique_constraint(:username)
      |> cast_attachments(params, @attachment_fields)
    end

    def registration_changeset(model, params \\ %{}) do
      model
      |> cast(params, [:password])
      |> changeset(params)
      |> validate_required([:password])
      |> encrypt_password
    end

    defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
      put_change(changeset, :password_hash, hashpwsalt(password))
    end

    defp encrypt_password(changeset), do: changeset

    def update_changeset(model, params \\ %{})  do
      model
      |> cast_attachments(params, @attachment_fields)
    end

    def order_by_inserted_at(query) do
      from answer in query,
      order_by: [desc: answer.inserted_at]
    end
    
    def newbies(query) do
      from user in query,
        where: user.inserted_at > ago(1, "week")
    end

    def count_followers(user) do
        followers_count =
          followers_query(user)
          |> Repo.aggregate(:count, :id)

        %User{user | followers_count: followers_count}
      end

      def count_following(user) do
        following_count =
          following_query(user)
          |> Repo.aggregate(:count, :id)

        %User{user | following_count: following_count}
      end

    defp followers_query(user), do: assoc(user, :followers)
    defp following_query(user), do: assoc(user, :following)
end
