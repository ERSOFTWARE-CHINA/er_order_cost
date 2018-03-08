defmodule RestfulApiWeb.Router do
  use RestfulApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do  
    plug Guardian.Plug.Pipeline, module: RestfulApiWeb.Guardian,
      error_handler: RestfulApiWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end


  scope "/", RestfulApiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", RestfulApiWeb do
    pipe_through :api
    post "/login", LoginController, :login
    resources "/users", UserController, except: [:new, :edit]
    resources "/roles", RoleController, except: [:new, :edit]
    resources "/organizations", OrganizationController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", RestfulApiWeb do
  #   pipe_through :api
  # end
end
