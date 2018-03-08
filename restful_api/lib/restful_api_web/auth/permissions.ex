defmodule RestfulBackendWeb.Permissions do
	use Guardian, otp_app: :restful_backend,
		permissions: %{
										# 每组最大31个权限
										default: [
												:read_dict, 
												:write_dict,
												:read_dept,
												:write_dept,
												:read_user,
												:write_user,
												:read_role,
												:write_role,  
										]  # 8个权限位，转换为十进制为255
										}
	use Guardian.Permissions.Bitwise

	#　通过plug做权限验证时，传递guardian plug options以简化代码
	def get_can_options(permission_list) do
		[module: RestfulBackendWeb.Permissions, ensure: %{default: permission_list}, error_handler: RestfulBackendWeb.AuthErrorHandler]
	end

	# 根据conn获取权限
	def get_perms_from_conn(conn) do
		resource = Guardian.Plug.current_resource(conn)
		case resource do
		nil -> 0
		resource ->
				roles = resource |> Map.get(:roles, [])
				case roles do
				nil -> 0
				roles ->
						roles
						|> Enum.map(fn(r) -> r.perms end)
						|> Enum.reduce(0, fn(n, acc) -> n ||| acc end)
				end
		end
	end

	# 由角色列表获得权限的整型表示
	def get_perms_from_roles(list) do
		case list do
		nil -> 0
		[] -> 0
		roles -> 
			roles
			|> Enum.map(fn(r) -> r.perms end)
			|> Enum.reduce(0, fn(n, acc) -> n ||| acc end)
		end
	end

	# 获取用户权限
	def get_permissions(conn) do
		perms = get_perms_from_conn(conn)
		claims = Guardian.Plug.current_claims(conn) |> Map.put("pem", %{"default" => perms}) 
		RestfulBackendWeb.Permissions.decode_permissions_from_claims(claims)
	end

	# 用来将权限放置到claims中的plug
	def build_claims(conn, _) do
		perms = get_perms_from_conn(conn)
		claims = Guardian.Plug.current_claims(conn) |> Map.put("pem", %{"default" => perms}) 
		conn |> Guardian.Plug.put_current_claims(claims)
	end
    
end
    