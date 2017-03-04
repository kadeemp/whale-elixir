defmodule Whale2.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :video_url, :string
      add :thumbnail_url, :string
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps()
    end
    create index(:answers, [:question_id])
  end
end
