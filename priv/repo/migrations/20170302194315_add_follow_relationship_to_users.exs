defmodule Whale2.Repo.Migrations.AddFollowRelationshipToUsers do
  use Ecto.Migration

  def change do
    create table(:relationships) do
        add :follower_id, references(:users, on_delete: :delete_all)
        add :followed_id, references(:users, on_delete: :delete_all)

        timestamps()
    end

    create index(:relationships, [:follower_id])
    create index(:relationships, [:followed_id])
    create index(:relationships, [:follower_id, :followed_id], unique: true)
  end
end
