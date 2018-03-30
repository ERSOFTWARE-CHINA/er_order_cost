defmodule RestfulApiWeb.ProductionStockinControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.ProductionStockinService
  alias RestfulApi.ProductionStockinService.ProductionStockin

  @create_attrs %{no: "some no"}
  @update_attrs %{no: "some updated no"}
  @invalid_attrs %{no: nil}

  def fixture(:production_stockin) do
    {:ok, production_stockin} = ProductionStockinService.create_production_stockin(@create_attrs)
    production_stockin
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all production_stockins", %{conn: conn} do
      conn = get conn, production_stockin_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create production_stockin" do
    test "renders production_stockin when data is valid", %{conn: conn} do
      conn = post conn, production_stockin_path(conn, :create), production_stockin: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, production_stockin_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "no" => "some no"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, production_stockin_path(conn, :create), production_stockin: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update production_stockin" do
    setup [:create_production_stockin]

    test "renders production_stockin when data is valid", %{conn: conn, production_stockin: %ProductionStockin{id: id} = production_stockin} do
      conn = put conn, production_stockin_path(conn, :update, production_stockin), production_stockin: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, production_stockin_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "no" => "some updated no"}
    end

    test "renders errors when data is invalid", %{conn: conn, production_stockin: production_stockin} do
      conn = put conn, production_stockin_path(conn, :update, production_stockin), production_stockin: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete production_stockin" do
    setup [:create_production_stockin]

    test "deletes chosen production_stockin", %{conn: conn, production_stockin: production_stockin} do
      conn = delete conn, production_stockin_path(conn, :delete, production_stockin)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, production_stockin_path(conn, :show, production_stockin)
      end
    end
  end

  defp create_production_stockin(_) do
    production_stockin = fixture(:production_stockin)
    {:ok, production_stockin: production_stockin}
  end
end
