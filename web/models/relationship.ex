defmodule Whale2.Relationship do
    use Whale2.Web, :model

    schema "relationships" do
        belongs_to :follower, User, foreign_key: :follower_id
        belongs_to :followed, User, foreign_key: :followed_id

        timestamps()
      end
end