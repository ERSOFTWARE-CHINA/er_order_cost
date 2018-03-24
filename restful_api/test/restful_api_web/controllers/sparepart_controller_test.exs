defmodule RestfulApiWeb.SparepartControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.SparepartService
  alias RestfulApi.SparepartService.Sparepart

  @create_attrs %{attributes: "some attributes", name: "some name", specifications: "some specifications"}
  @update_attrs %{attributes: "some updated attributes", name: "some updated name", specifications: "some updated specifications"}
  @invalid_attrs %{attributes: nil, name: nil, specifications: nil}

  def fixture(:sparepart) do
    {:ok, sparepart} = SparepartService.create_sparepart(@create_attrs)
    sparepart
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all spareparts", %{conn: conn} do
      conn = get conn, sparepart_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create sparepart" do
    test "renders sparepart when data is valid", %{conn: conn} do
      conn = post conn, sparepart_path(conn, :create), sparepart: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, sparepart_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributes" => "some attributes",
        "name" => "some name",
        "specifications" => "some specifications"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, sparepart_path(conn, :create), sparepart: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update sparepart" do
    setup [:create_sparepart]

    test "renders sparepart when data is valid", %{conn: conn, sparepart: %Sparepart{id: id} = sparepart} do
      conn = put conn, sparepart_path(conn, :update, sparepart), sparepart: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, sparepart_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributes" => "some updated attributes",
        "name" => "some updated name",
        "specifications" => "some updated specifications"}
    end

    test "renders errors when data is invalid", %{conn: conn, sparepart: sparepart} do
      conn = put conn, sparepart_path(conn, :update, sparepart), sparepart: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete sparepart" do
    setup [:create_sparepart]

    test "deletes chosen sparepart", %{conn: conn, sparepart: sparepart} do
      conn = delete conn, sparepart_path(conn, :delete, sparepart)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, sparepart_path(conn, :show, sparepart)
      end
    end
  end

  defp create_sparepart(_) do
    sparepart = fixture(:sparepart)
    {:ok, sparepart: sparepart}
  end
end
