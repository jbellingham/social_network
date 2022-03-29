defmodule SocialNetworkWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias SocialNetworkWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Routes.post_index_path(conn, :index))
      # One may assume that the redirect on the previous line sort of short-circuits the rest of this request --
      # That doesn't seem to be the case, and the request will pass on to subsequent plugs and eventually the
      # destination controller, unless we halt here as below.
      |> halt()
    end
  end
end
