defmodule RestfulApi.Authentication do

  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.Authentication.Role

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.Authentication
      use RestfulApi.BaseContext
      alias RestfulApi.Authentication.Role
    end
  end

  def page(params) do 
    Role
    |> query_like(params, "name")
    |> get_pagination(params)
  end
end
