defmodule SocialNetworkWeb.Controllers.AuthController do
  use SocialNetworkWeb, :controller
  plug Ueberauth

  alias SocialNetwork.Schema.User
  alias SocialNetwork.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "auth0"}
    sign_in(conn, User.changeset(%User{}, user_params))
  end

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: Routes.post_index_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.post_index_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Couldn't sign in.")
        |> redirect(to: Routes.post_index_path(conn, :index))
    end
  end

  # defp = private function
  defp insert_or_update_user(changeset) do
     case Repo.get_by(User, email: changeset.changes.email) do
        nil ->
          Repo.insert(changeset)
        user ->
          {:ok, user}
      end
  end
end
