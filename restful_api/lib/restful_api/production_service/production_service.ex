defmodule RestfulApi.ProductionService do
  @moduledoc """
  The ProductionService context.
  """

  import Ecto.Query, warn: false
  alias RestfulApi.Repo

  alias RestfulApi.ProductionService.Production

  use RestfulApi.BaseContext

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.ProductionService
      use RestfulApi.BaseContext
      alias RestfulApi.ProductionService.Production
    end
  end

  def page(params, conn) do
    Production
    |> query_like(params, "name")
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
