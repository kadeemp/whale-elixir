defmodule Whale2.User do
    use Whale2.Web, :model
    use Arc.Ecto.Schema

    schema "users" do
        field :first_name, :string
        field :last_name, :string
        field :username, :string
        field :email, :string
        field :image_url, Whale2.Uploaders.UserImage.Type

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
