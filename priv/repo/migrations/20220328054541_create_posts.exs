defmodule SocialNetwork.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string

      timestamps()
    end
  end
end
