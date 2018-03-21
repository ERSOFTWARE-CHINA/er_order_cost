defmodule RestfulApiWeb.Permissions do
	use Guardian, otp_app: :restful_backend,
		permissions: %{
					# 每组最大31个权限
					default: [
							:base_bit,
							:read_model01, 
							:write_model01,
							:read_model02, 
							:write_model02,
							:read_model03, 
							:write_model03,
							:read_model04, 
							:write_model04,
							:read_model05, 
							:write_model05,
							:read_model06, 
							:write_model06,
							:read_model07, 
							:write_model07,
							:read_model07, 
							:write_model08,
							:read_model09, 
							:write_model09,
							:read_model10, 
							:write_model10,
							:read_model11, 
							:write_model11,
							:read_model12, 
							:write_model12,
							:read_model13, 
							:write_model13,
							:read_model14, 
							:write_model14,
							:read_model15, 
							:write_model15,
							:read_model15, 
							:write_model15,
							:read_model16, 
							:write_model16,  
							:read_model17, 
							:write_model17         
					]  # 31个权限位：2147483647
					}
	use Guardian.Permissions.Bitwise

	#　通过plug做权限验证时，传递guardian plug options以简化代码
	def need_perms(permission_list) do
		[module: RestfulApiWeb.Permissions, ensure: %{default: permission_list}, error_handler: RestfulApiWeb.AuthErrorHandler]
	end

	# 由角色列表获得权限的整型表示
	def get_perms_from_roles(list) do
		case list do
      nil -> 0
      [] -> 0
      roles -> 
        roles
        |> Enum.map(fn(r) -> r.perms_number end)
        |> Enum.reduce(0, fn(n, acc) -> n ||| acc end)
      end
    end

	# 获取用户权限
	def get_permissions(claims) do
		RestfulApiWeb.Permissions.decode_permissions_from_claims(claims)
		
	end

	# 获取所有权限的列表
	def get_all_permissions() do
		RestfulApiWeb.Permissions.available_permissions
	end

	# 获取最大权限数值
	def get_max_perms_number() do
		RestfulApiWeb.Permissions.available_permissions
		|> RestfulApiWeb.Permissions.encode_permissions!
	end

end
    