defmodule SocialNetworkWeb.LiveViewAssigns do
  import Phoenix.LiveView
  alias SocialNetwork.Repo
  alias SocialNetworkWeb.Router.Helpers, as: Routes
  alias SocialNetwork.Repositories.Posts

  def on_mount(:user, _params, %{"user_id" => user_id} = _session, socket) do
    IO.puts("Live View user_id assign happened")
    socket = assign_new(socket, :current_user, fn ->
      Repo.get_by(User, id: user_id)
    end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      put_flash(socket, :info, "You must be signed in to do that.")
      {:halt, redirect(socket, to: Routes.post_index_path(socket, :index))}
    end
  end

  # def on_mount(:owns_target, %{"id" => id} = _params, %{"user_id" => user_id} = _session, socekt) do
  #   socket = assign_new(socket, :owns_target, fn ->
  #     post = id && Posts.get_post(id) ->
  #       post.user_id == user_id
  #   end)
  # end
end
