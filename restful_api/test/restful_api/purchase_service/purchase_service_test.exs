defmodule RestfulApi.PurchaseServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.PurchaseService

  describe "perchases" do
    alias RestfulApi.PurchaseService.Purchase

    @valid_attrs %{pno: 42}
    @update_attrs %{pno: 43}
    @invalid_attrs %{pno: nil}

    def purchase_fixture(attrs \\ %{}) do
      {:ok, purchase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PurchaseService.create_purchase()

      purchase
    end

    test "list_perchases/0 returns all perchases" do
      purchase = purchase_fixture()
      assert PurchaseService.list_perchases() == [purchase]
    end

    test "get_purchase!/1 returns the purchase with given id" do
      purchase = purchase_fixture()
      assert PurchaseService.get_purchase!(purchase.id) == purchase
    end

    test "create_purchase/1 with valid data creates a purchase" do
      assert {:ok, %Purchase{} = purchase} = PurchaseService.create_purchase(@valid_attrs)
      assert purchase.pno == 42
    end

    test "create_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PurchaseService.create_purchase(@invalid_attrs)
    end

    test "update_purchase/2 with valid data updates the purchase" do
      purchase = purchase_fixture()
      assert {:ok, purchase} = PurchaseService.update_purchase(purchase, @update_attrs)
      assert %Purchase{} = purchase
      assert purchase.pno == 43
    end

    test "update_purchase/2 with invalid data returns error changeset" do
      purchase = purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = PurchaseService.update_purchase(purchase, @invalid_attrs)
      assert purchase == PurchaseService.get_purchase!(purchase.id)
    end

    test "delete_purchase/1 deletes the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{}} = PurchaseService.delete_purchase(purchase)
      assert_raise Ecto.NoResultsError, fn -> PurchaseService.get_purchase!(purchase.id) end
    end

    test "change_purchase/1 returns a purchase changeset" do
      purchase = purchase_fixture()
      assert %Ecto.Changeset{} = PurchaseService.change_purchase(purchase)
    end
  end
end
