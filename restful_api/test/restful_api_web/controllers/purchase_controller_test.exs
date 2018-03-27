defmodule RestfulApiWeb.PurchaseControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.PurchaseService
  alias RestfulApi.PurchaseService.Purchase

  @create_attrs %{pno: 42}
  @update_attrs %{pno: 43}
  @invalid_attrs %{pno: nil}

  def fixture(:purchase) do
    {:ok, purchase} = PurchaseService.create_purchase(@create_attrs)
    purchase
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all perchases", %{conn: conn} do
      conn = get conn, purchase_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create purchase" do
    test "renders purchase when data is valid", %{conn: conn} do
      conn = post conn, purchase_path(conn, :create), purchase: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, purchase_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "pno" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, purchase_path(conn, :create), purchase: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update purchase" do
    setup [:create_purchase]

    test "renders purchase when data is valid", %{conn: conn, purchase: %Purchase{id: id} = purchase} do
      conn = put conn, purchase_path(conn, :update, purchase), purchase: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, purchase_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "pno" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, purchase: purchase} do
      conn = put conn, purchase_path(conn, :update, purchase), purchase: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete purchase" do
    setup [:create_purchase]

    test "deletes chosen purchase", %{conn: conn, purchase: purchase} do
      conn = delete conn, purchase_path(conn, :delete, purchase)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, purchase_path(conn, :show, purchase)
      end
    end
  end

  defp create_purchase(_) do
    purchase = fixture(:purchase)
    {:ok, purchase: purchase}
  end
end
