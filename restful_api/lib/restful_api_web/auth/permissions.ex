defmodule RestfulApiWeb.Permissions do
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
              
              # :order,
              # :purchase,
              # :takeMaterial,
              # :product,
              # :employee,
              # :supplier,
              # :customer
					]  # 8个权限位，转换为十进制为255
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
        |> Enum.map(fn(r) -> r.perms end)
        |> Enum.reduce(0, fn(n, acc) -> n ||| acc end)
      end
	end

	# 获取用户权限
	def get_permissions(claims) do
		RestfulApiWeb.Permissions.decode_permissions_from_claims(claims)
	end

end
    