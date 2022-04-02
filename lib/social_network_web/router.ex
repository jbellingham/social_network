defmodule SocialNetworkWeb.Router do
  use SocialNetworkWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SocialNetworkWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SocialNetworkWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Order of routes matters. It checks routes sequentially down,
  # so a request to /new will fall into - live "/new", PostLive.Index, :new -
  # It would otherwise fall into - live "/:id", PostLive.Show, :show -
  # where "new" would be interpreted as an id.
  scope "/", SocialNetworkWeb do
    pipe_through [:browser]

    live "/new", PostLive.Index, :new
    live "/:id/edit", PostLive.Index, :edit
    live "/:id/show/edit", PostLive.Show, :edit
  end

  scope "/", SocialNetworkWeb do
    pipe_through :browser

    live "/", PostLive.Index, :index

    live "/:id", PostLive.Show, :show

    # get "/logout", AuthController, :logout
  end

  scope "/auth", SocialNetworkWeb do
    pipe_through :browser
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SocialNetworkWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SocialNetworkWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
