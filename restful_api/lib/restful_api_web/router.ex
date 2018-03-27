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
  end

  scope "/api/v1", RestfulApiWeb do
    pipe_through [:api, :api_auth]

    resources "/projects", ProjectController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/project_users", ProjectUserController, except: [:new, :edit]
    resources "/roles", RoleController, except: [:new, :edit]
    get "/permissions", RoleController, :list_all_perms
    resources "/organizations", OrganizationController, except: [:new, :edit]
    resources "/conts", ContsController, except: [:new, :edit]
    get "/users/check/name", UserController, :check_name
    get "/users/email/:email", UserController, :check_email
    get "/projects/check/name", ProjectController, :check_name


    #产品信息配置
    resources "/prodctions", ProductionController, except: [:new, :edit]
    #配件信息配置
    resources "/spareparts", SparepartController, except: [:new, :edit]
    #订单信息配置
    resources "/orders",OrderController,except: [:new,:edit]
    #采购单信息配置
    resources "/purchases", PurchaseController, except: [:new, :edit]
    

  end

end
