defmodule RestfulApi.SparepartService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.SparepartService.Sparepart

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.SparepartService
      use RestfulApi.BaseContext
      alias RestfulApi.SparepartService.Sparepart
    end
  end

  def page(params, conn) do 
    Sparepart
    |> query_like(params, "name")
    |> query_like(params, "attributes")
    |> query_like(params, "specifications")
    |> query_order_by(params, "name")
    |> get_pagination(params, conn)
  end

  def check_name_exists(%{"id" => id, "name" => name}) do
    Production
    |> Repo.get_by(name: name)
    |> case do
      nil ->
        {:ok, name}

      production ->
        case production.id == id do
          true -> {:ok, name}
          false -> {:error, name}
        end
    end
  end

end
