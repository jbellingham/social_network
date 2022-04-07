defmodule SocialNetworkWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias SocialNetwork.Repo
  alias SocialNetwork.Schema.User

  def init(_params) do
  end

  # the params argument in the call function of a plug
  # is the return value of the plug's init function
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      # Read this line fairly literally -- if user_id is defined, and if Repo.get() returns a value
      # user will be assigned to the return value of Repo.get(), and the -> block will be executed
      user = user_id && Repo.get(User, user_id) ->
        # in any other request-- conn.assigns.user => user struct
        #
        # plugs are executed in a predefined order, so subsequent plugs will have access to the user
        # in the same way
        assign(conn, :current_user, user)

      # cond statements can have a default case like the following
      true ->
        assign(conn, :current_user, nil)
    end
  end
end
