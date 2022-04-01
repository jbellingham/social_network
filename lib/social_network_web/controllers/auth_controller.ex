defmodule SocialNetworkWeb.AuthController do
  use SocialNetworkWeb, :controller
  plug Ueberauth

  alias SocialNetwork.Models.User
  alias SocialNetwork.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.inspect(auth)
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "auth0"}

    sign_in(conn, User.changeset(%User{}, user_params))
  end

  def signout(conn, _params) do
    conn
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
