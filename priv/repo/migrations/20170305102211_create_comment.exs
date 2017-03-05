defmodule Whale2.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :commenter_id, references(:users, on_delete: :delete_all)
      add :answer_id, references(:answers, on_delete: :delete_all)

      timestamps()
    end
    create index(:comments, [:commenter_id])
    create index(:comments, [:answer_id])

  end
end
