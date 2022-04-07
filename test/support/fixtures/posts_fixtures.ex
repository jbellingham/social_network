defmodule SocialNetwork.Repositories.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocialNetwork.Repositories.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(user, attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> SocialNetwork.Repositories.Posts.create_post(user)

    post
  end
end
