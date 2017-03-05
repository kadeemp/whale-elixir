defmodule Whale2.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :content, :string
      add :categories, {:array, :string}
      add :sender_id, references(:users, on_delete: :delete_all)
      add :receiver_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:questions, [:sender_id, :receiver_id])
  end
end
