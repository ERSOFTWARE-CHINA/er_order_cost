defmodule RestfulApi.ProductionStockinService do
  @moduledoc """
  产品入库单Service
  """
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.ProductionStockinService.ProductionStockin
  alias RestfulApi.ProductionStockService.ProductionStock
  alias RestfulApi.ProductionService.Production

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.ProductionStockinService
      use RestfulApi.BaseContext
      alias RestfulApi.ProductionStockinService.ProductionStockin
    end
  end

  def page(params, conn) do 
    ProductionStockin
    |> query_like(params, "no")
    |> query_equal(params, "production_id")
    |> query_order_desc_by(params, "inserted_at")
    |> get_pagination(params, conn)
  end

  # 创建产品入库单，并创建产品库存
  def create_stockin(prodstockin_changeset, conn) do
    Repo.transaction(fn ->
      {:ok, entity} = save_create(prodstockin_changeset, conn)
      entity
      |> create_stock(conn)
    end)
  end

  # 更新产品入库单，并更新产品库存
  def update_stockin(prodstockin_changeset, conn) do
    Repo.transaction(fn ->
      {:ok, entity} = save_update(prodstockin_changeset, conn)
      entity
      |> delete_stock(conn)
      |> create_stock(conn)
    end)
  end

  # 删除产品入库单，并删除产品库存
  def delete_stockin(struct, id, conn) do
    Repo.transaction(fn ->
      case delete_by_id(struct, id, conn) do
        {:ok, entity} ->
          entity |> delete_stock(conn)
        {:error, _} -> {:error, :not_found}
      end
    end)
  end

  # 根据产品入库单生成产品库存
  defp create_stock(prod_stockin, conn) do
    params = prod_stockin
    |> Map.from_struct
    prod_stock_changeset = ProductionStock.changeset(%ProductionStock{},params)
    case get_by_id(Production, prod_stockin.production_id, conn) do
      {:ok, entity} ->
        prod_stock_changeset = Ecto.Changeset.put_assoc(prod_stock_changeset, :production, entity)
        save_create(prod_stock_changeset, conn)
      {:error, _} -> 
        save_create(prod_stock_changeset, conn)
    end
    prod_stockin
  end

  # 删除产品入库单关联的产品库存信息
  defp delete_stock(prod_stockin, conn) do
    ProductionStock
    |> query_equal(%{"no" => prod_stockin.no}, "no")
    |> list_all(conn)
    |> Enum.map(fn(e) -> Repo.delete(e) end)
    prod_stockin
  end
  
end
