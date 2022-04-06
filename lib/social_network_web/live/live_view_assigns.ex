defmodule SocialNetworkWeb.LiveViewAssigns do
  import Phoenix.LiveView
  alias SocialNetwork.Repo
  alias SocialNetwork.Schema.User

  def on_mount(:user, _params, session, socket) do
    user_id = Map.get(session, "user_id")
    socket = assign_new(socket, :current_user, fn ->
      get_user_if_not_nil(user_id)
    end)

  {:cont, socket}
  end

  # pattern matching functions
  # if function receives nil, it will match to this definition
  defp get_user_if_not_nil(nil) do
    nil
  end

  # if function does not receive nil, it will match to this definition
  defp get_user_if_not_nil(user_id) do
    Repo.get(User, user_id)
  end

  # def on_mount(:owns_target, %{"id" => id} = _params, %{"user_id" => user_id} = _session, socekt) do
  #   socket = assign_new(socket, :owns_target, fn ->
  #     post = id && Posts.get_post(id) ->
  #       post.user_id == user_id
  #   end)
  # end
end
