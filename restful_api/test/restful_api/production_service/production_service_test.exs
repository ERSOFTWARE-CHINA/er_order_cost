defmodule RestfulApi.ProductionServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.ProductionService

  describe "prodctions" do
    alias RestfulApi.ProductionService.Production

    @valid_attrs %{attributes: "some attributes", name: "some name", specifications: "some specifications"}
    @update_attrs %{attributes: "some updated attributes", name: "some updated name", specifications: "some updated specifications"}
    @invalid_attrs %{attributes: nil, name: nil, specifications: nil}

    def production_fixture(attrs \\ %{}) do
      {:ok, production} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductionService.create_production()

      production
    end

    test "list_prodctions/0 returns all prodctions" do
      production = production_fixture()
      assert ProductionService.list_prodctions() == [production]
    end

    test "get_production!/1 returns the production with given id" do
      production = production_fixture()
      assert ProductionService.get_production!(production.id) == production
    end

    test "create_production/1 with valid data creates a production" do
      assert {:ok, %Production{} = production} = ProductionService.create_production(@valid_attrs)
      assert production.attributes == "some attributes"
      assert production.name == "some name"
      assert production.specifications == "some specifications"
    end

    test "create_production/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductionService.create_production(@invalid_attrs)
    end

    test "update_production/2 with valid data updates the production" do
      production = production_fixture()
      assert {:ok, production} = ProductionService.update_production(production, @update_attrs)
      assert %Production{} = production
      assert production.attributes == "some updated attributes"
      assert production.name == "some updated name"
      assert production.specifications == "some updated specifications"
    end

    test "update_production/2 with invalid data returns error changeset" do
      production = production_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductionService.update_production(production, @invalid_attrs)
      assert production == ProductionService.get_production!(production.id)
    end

    test "delete_production/1 deletes the production" do
      production = production_fixture()
      assert {:ok, %Production{}} = ProductionService.delete_production(production)
      assert_raise Ecto.NoResultsError, fn -> ProductionService.get_production!(production.id) end
    end

    test "change_production/1 returns a production changeset" do
      production = production_fixture()
      assert %Ecto.Changeset{} = ProductionService.change_production(production)
    end
  end
end
