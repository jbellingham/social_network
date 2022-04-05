defmodule SocialNetwork.Repositories.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocialNetwork.Repositories.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@example.com",
        token: "Some token",
        provider: "Some provider"
      })
      |> SocialNetwork.Repositories.Users.create_user()

    user
  end
end
