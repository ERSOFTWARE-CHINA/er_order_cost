defmodule RestfulApiWeb.Plugs.Auth do
  use RestfulApiWeb, :controller
  import Plug.Conn

  alias RestfulApiWeb.Guardian
  alias RestfulApi.Repo
  alias RestfulApi.Tenant.Project

  # 验证登陆用户是否为根用户(root)
  def auth_root(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_root do
      true -> conn
      false -> json conn, %{error: "You are not a root user!"}
    end
  end

  # 验证登陆用户是否为管理员用户(admin)
  def auth_admin(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_admin do
      true -> conn
      false -> json conn, %{error: "You are not a admin user!"}
    end
  end

  # 验证登陆用户所属项目是否可用，不验证root用户
  def project_active(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_root do
      false ->
        project = Repo.get(Project, resource.project_id)
        case project.actived do
          true -> conn
          false -> json conn, %{error: "Your project is disabled!"}
        end
      true -> conn
    end
  end

end