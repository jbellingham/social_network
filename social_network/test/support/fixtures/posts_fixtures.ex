defmodule SocialNetwork.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SocialNetwork.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> SocialNetwork.Posts.create_post()

    post
  end
end
