defmodule RestfulApi.ProductionStockinServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.ProductionStockinService

  describe "production_stockins" do
    alias RestfulApi.ProductionStockinService.ProductionStockin

    @valid_attrs %{no: "some no"}
    @update_attrs %{no: "some updated no"}
    @invalid_attrs %{no: nil}

    def production_stockin_fixture(attrs \\ %{}) do
      {:ok, production_stockin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductionStockinService.create_production_stockin()

      production_stockin
    end

    test "list_production_stockins/0 returns all production_stockins" do
      production_stockin = production_stockin_fixture()
      assert ProductionStockinService.list_production_stockins() == [production_stockin]
    end

    test "get_production_stockin!/1 returns the production_stockin with given id" do
      production_stockin = production_stockin_fixture()
      assert ProductionStockinService.get_production_stockin!(production_stockin.id) == production_stockin
    end

    test "create_production_stockin/1 with valid data creates a production_stockin" do
      assert {:ok, %ProductionStockin{} = production_stockin} = ProductionStockinService.create_production_stockin(@valid_attrs)
      assert production_stockin.no == "some no"
    end

    test "create_production_stockin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductionStockinService.create_production_stockin(@invalid_attrs)
    end

    test "update_production_stockin/2 with valid data updates the production_stockin" do
      production_stockin = production_stockin_fixture()
      assert {:ok, production_stockin} = ProductionStockinService.update_production_stockin(production_stockin, @update_attrs)
      assert %ProductionStockin{} = production_stockin
      assert production_stockin.no == "some updated no"
    end

    test "update_production_stockin/2 with invalid data returns error changeset" do
      production_stockin = production_stockin_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductionStockinService.update_production_stockin(production_stockin, @invalid_attrs)
      assert production_stockin == ProductionStockinService.get_production_stockin!(production_stockin.id)
    end

    test "delete_production_stockin/1 deletes the production_stockin" do
      production_stockin = production_stockin_fixture()
      assert {:ok, %ProductionStockin{}} = ProductionStockinService.delete_production_stockin(production_stockin)
      assert_raise Ecto.NoResultsError, fn -> ProductionStockinService.get_production_stockin!(production_stockin.id) end
    end

    test "change_production_stockin/1 returns a production_stockin changeset" do
      production_stockin = production_stockin_fixture()
      assert %Ecto.Changeset{} = ProductionStockinService.change_production_stockin(production_stockin)
    end
  end
end
