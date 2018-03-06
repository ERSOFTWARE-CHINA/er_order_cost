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

    resources "/users", UserController, except: [:new, :edit]
    resources "/roles", RoleController, except: [:new, :edit]
    resources "/organizations", OrganizationController, except: [:new, :edit]
  end

  scope "/", RestfulApiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RestfulApiWeb do
  #   pipe_through :api
  # end
end
