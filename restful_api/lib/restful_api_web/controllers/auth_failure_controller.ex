defmodule RestfulApiWeb.AuthFailureController do
  use RestfulApiWeb, :controller
  
  def auth_error( conn, _ ) do
    json conn, %{ error: "身份验证失败，未授权的访问！" }
  end

  def find_user_error( conn, _ ) do
    json conn, %{ error: "无法获取当前用户，可能是授权已过期，请尝试重新登录！" }
  end

  def project_error( conn, _ ) do
    json conn, %{ error: "用户所属项目已禁用！" }
  end
end