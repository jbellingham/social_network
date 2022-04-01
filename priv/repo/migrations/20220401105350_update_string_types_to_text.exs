defmodule SocialNetwork.Repo.Migrations.UpdateStringTypesToText do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :body, :text
    end

    alter table(:users) do
      modify :email, :text
      modify :provider, :text
      modify :token, :text
    end
  end
end
