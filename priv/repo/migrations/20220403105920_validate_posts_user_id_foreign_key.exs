defmodule SocialNetwork.Repo.Migrations.ValidatePostsUserIdForeignKey do
  use Ecto.Migration

  def change do
    execute "ALTER table posts VALIDATE CONSTRAINT posts_user_id_fkey", ""
  end
end
