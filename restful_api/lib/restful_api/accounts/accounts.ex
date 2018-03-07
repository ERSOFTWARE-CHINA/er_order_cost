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

end
