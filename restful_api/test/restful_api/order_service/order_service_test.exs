defmodule RestfulApi.OrderServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.OrderService

  describe "orders" do
    alias RestfulApi.OrderService.Order

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OrderService.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert OrderService.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OrderService.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = OrderService.create_order(@valid_attrs)
      assert order.name == "some name"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderService.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = OrderService.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.name == "some updated name"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderService.update_order(order, @invalid_attrs)
      assert order == OrderService.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = OrderService.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> OrderService.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = OrderService.change_order(order)
    end
  end
end
