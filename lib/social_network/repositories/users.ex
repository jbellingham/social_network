defmodule SocialNetwork.Repositories.Users do
  alias SocialNetwork.Repo
  alias SocialNetwork.Schema.User
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    user = User.changeset(%User{}, attrs)
    Repo.insert(user)
  end
end
