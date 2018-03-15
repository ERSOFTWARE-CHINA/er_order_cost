defmodule RestfulApiWeb.ContsControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.Conts
  alias RestfulApi.Conts.Model.Conts

  @create_attrs %{category: "some category", name: "some name", value: "some value"}
  @update_attrs %{category: "some updated category", name: "some updated name", value: "some updated value"}
  @invalid_attrs %{category: nil, name: nil, value: nil}

  def fixture(:conts) do
    {:ok, conts} = Conts.create_conts(@create_attrs)
    conts
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all conts", %{conn: conn} do
      conn = get conn, conts_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create conts" do
    test "renders conts when data is valid", %{conn: conn} do
      conn = post conn, conts_path(conn, :create), conts: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, conts_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "category" => "some category",
        "name" => "some name",
        "value" => "some value"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, conts_path(conn, :create), conts: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update conts" do
    setup [:create_conts]

    test "renders conts when data is valid", %{conn: conn, conts: %Conts{id: id} = conts} do
      conn = put conn, conts_path(conn, :update, conts), conts: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, conts_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "category" => "some updated category",
        "name" => "some updated name",
        "value" => "some updated value"}
    end

    test "renders errors when data is invalid", %{conn: conn, conts: conts} do
      conn = put conn, conts_path(conn, :update, conts), conts: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete conts" do
    setup [:create_conts]

    test "deletes chosen conts", %{conn: conn, conts: conts} do
      conn = delete conn, conts_path(conn, :delete, conts)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, conts_path(conn, :show, conts)
      end
    end
  end

  defp create_conts(_) do
    conts = fixture(:conts)
    {:ok, conts: conts}
  end
end
