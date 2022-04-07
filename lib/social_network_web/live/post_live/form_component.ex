defmodule SocialNetworkWeb.PostLive.FormComponent do
  use SocialNetworkWeb, :live_component

  alias SocialNetwork.Repositories.Posts
  alias SocialNetwork.Schema.Post
  alias SocialNetworkWeb.Router.Helpers, as: Routes

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Posts.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Posts.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    current_user = socket.assigns.current_user

    if current_user do
      save_post(socket, socket.assigns.action, post_params, current_user)
    else
      # put_flash doesn't work, need to figure out how to display an error here
      put_flash(socket, :error, "You must be logged in to do that.")
      {:noreply, socket}
    end
  end

  defp save_post(socket, :edit, post_params, _user) do
    case Posts.update_post(socket.assigns.post, post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params, user) do
    case Posts.create_post(post_params, user) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
