defmodule RestfulApiWeb.ProductionControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.ProductionService
  alias RestfulApi.ProductionService.Production

  @create_attrs %{attributes: "some attributes", name: "some name", specifications: "some specifications"}
  @update_attrs %{attributes: "some updated attributes", name: "some updated name", specifications: "some updated specifications"}
  @invalid_attrs %{attributes: nil, name: nil, specifications: nil}

  def fixture(:production) do
    {:ok, production} = ProductionService.create_production(@create_attrs)
    production
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all productions", %{conn: conn} do
      conn = get conn, production_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create production" do
    test "renders production when data is valid", %{conn: conn} do
      conn = post conn, production_path(conn, :create), production: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, production_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributes" => "some attributes",
        "name" => "some name",
        "specifications" => "some specifications"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, production_path(conn, :create), production: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update production" do
    setup [:create_production]

    test "renders production when data is valid", %{conn: conn, production: %Production{id: id} = production} do
      conn = put conn, production_path(conn, :update, production), production: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, production_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributes" => "some updated attributes",
        "name" => "some updated name",
        "specifications" => "some updated specifications"}
    end

    test "renders errors when data is invalid", %{conn: conn, production: production} do
      conn = put conn, production_path(conn, :update, production), production: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete production" do
    setup [:create_production]

    test "deletes chosen production", %{conn: conn, production: production} do
      conn = delete conn, production_path(conn, :delete, production)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, production_path(conn, :show, production)
      end
    end
  end

  defp create_production(_) do
    production = fixture(:production)
    {:ok, production: production}
  end
end
