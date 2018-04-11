defmodule RestfulApiWeb.Plugs.Auth do
  use RestfulApiWeb, :controller
  import Plug.Conn

  alias RestfulApiWeb.Guardian
  alias RestfulApi.Repo
  alias RestfulApi.Tenant.Project

  # 验证登陆用户是否为根用户(root)
  def auth_root(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    if is_nil(resource) do
      conn |> redirect(to: "/cannot_find_user") |> halt()
    else
      case resource.is_root do
        true -> conn
        false -> conn |> redirect(to: "/auth_failure") |> halt()
      end
    end
    
  end

  # 验证登陆用户是否为管理员用户(admin),root用户将直接通过验证
  def auth_admin(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    if is_nil(resource) do
      conn |> redirect(to: "/cannot_find_user") |> halt()
    else
      case resource.is_admin || resource.is_root do
        true -> conn
        false -> 
          conn |> redirect(to: "/auth_failure") |> halt()
      end
    end
  end

  # 验证登陆用户所属项目是否可用，root用户将直接通过验证
  def project_active(conn, _) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    if is_nil(resource) do
      conn |> redirect(to: "/cannot_find_user") |> halt()
    else
      case resource.is_root do
        false ->
          project = Repo.get(Project, resource.project_id)
          case project.actived do
            true -> conn
            false -> conn |> redirect(to: "/project_disable") |> halt()
          end
        true -> conn
      end
    end
  end

end