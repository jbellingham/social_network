defmodule SocialNetwork.Repo.Migrations.AddUserIdToPosts do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :user_id, references("users", validate: false)
    end
  end
end
