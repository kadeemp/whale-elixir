defmodule Whale2.User do
  use Whale2.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end
end
