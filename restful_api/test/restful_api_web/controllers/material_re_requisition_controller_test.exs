defmodule RestfulApiWeb.MaterialRequisitionControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.MaterialRequisitionService
  alias RestfulApi.MaterialRequisitionService.MaterialRequisition

  @create_attrs %{no: "some no"}
  @update_attrs %{no: "some updated no"}
  @invalid_attrs %{no: nil}

  def fixture(:material_requisition) do
    {:ok, material_requisition} = MaterialRequisitionService.create_material_requisition(@create_attrs)
    material_requisition
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all material_requisitions", %{conn: conn} do
      conn = get conn, material_requisition_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create material_requisition" do
    test "renders material_requisition when data is valid", %{conn: conn} do
      conn = post conn, material_requisition_path(conn, :create), material_requisition: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, material_requisition_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "no" => "some no"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, material_requisition_path(conn, :create), material_requisition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update material_requisition" do
    setup [:create_material_requisition]

    test "renders material_requisition when data is valid", %{conn: conn, material_requisition: %MaterialRequisition{id: id} = material_requisition} do
      conn = put conn, material_requisition_path(conn, :update, material_requisition), material_requisition: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, material_requisition_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "no" => "some updated no"}
    end

    test "renders errors when data is invalid", %{conn: conn, material_requisition: material_requisition} do
      conn = put conn, material_requisition_path(conn, :update, material_requisition), material_requisition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete material_requisition" do
    setup [:create_material_requisition]

    test "deletes chosen material_requisition", %{conn: conn, material_requisition: material_requisition} do
      conn = delete conn, material_requisition_path(conn, :delete, material_requisition)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, material_requisition_path(conn, :show, material_requisition)
      end
    end
  end

  defp create_material_requisition(_) do
    material_requisition = fixture(:material_requisition)
    {:ok, material_requisition: material_requisition}
  end
end
