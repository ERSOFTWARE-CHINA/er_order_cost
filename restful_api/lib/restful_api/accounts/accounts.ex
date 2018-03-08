defmodule RestfulApi.Accounts do

  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.Accounts.User

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.Accounts
      use RestfulApi.BaseContext
      alias RestfulApi.Accounts.User
    end
  end

  def page(params) do 
    User
    |> query_like(params, "name")
    |> query_like(params, "email")
    |> query_like(params, "position")
    |> query_equal(params, "is_admin")
    |> query_equal(params, "organization_id")
    |> query_order_by(params, "name")
    |> query_preload(:roles)
    |> query_preload(:organization)
    |> get_pagination(params)
  end

end
