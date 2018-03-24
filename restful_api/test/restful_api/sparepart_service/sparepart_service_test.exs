defmodule RestfulApi.SparepartServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.SparepartService

  describe "spareparts" do
    alias RestfulApi.SparepartService.Sparepart

    @valid_attrs %{attributes: "some attributes", name: "some name", specifications: "some specifications"}
    @update_attrs %{attributes: "some updated attributes", name: "some updated name", specifications: "some updated specifications"}
    @invalid_attrs %{attributes: nil, name: nil, specifications: nil}

    def sparepart_fixture(attrs \\ %{}) do
      {:ok, sparepart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SparepartService.create_sparepart()

      sparepart
    end

    test "list_spareparts/0 returns all spareparts" do
      sparepart = sparepart_fixture()
      assert SparepartService.list_spareparts() == [sparepart]
    end

    test "get_sparepart!/1 returns the sparepart with given id" do
      sparepart = sparepart_fixture()
      assert SparepartService.get_sparepart!(sparepart.id) == sparepart
    end

    test "create_sparepart/1 with valid data creates a sparepart" do
      assert {:ok, %Sparepart{} = sparepart} = SparepartService.create_sparepart(@valid_attrs)
      assert sparepart.attributes == "some attributes"
      assert sparepart.name == "some name"
      assert sparepart.specifications == "some specifications"
    end

    test "create_sparepart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SparepartService.create_sparepart(@invalid_attrs)
    end

    test "update_sparepart/2 with valid data updates the sparepart" do
      sparepart = sparepart_fixture()
      assert {:ok, sparepart} = SparepartService.update_sparepart(sparepart, @update_attrs)
      assert %Sparepart{} = sparepart
      assert sparepart.attributes == "some updated attributes"
      assert sparepart.name == "some updated name"
      assert sparepart.specifications == "some updated specifications"
    end

    test "update_sparepart/2 with invalid data returns error changeset" do
      sparepart = sparepart_fixture()
      assert {:error, %Ecto.Changeset{}} = SparepartService.update_sparepart(sparepart, @invalid_attrs)
      assert sparepart == SparepartService.get_sparepart!(sparepart.id)
    end

    test "delete_sparepart/1 deletes the sparepart" do
      sparepart = sparepart_fixture()
      assert {:ok, %Sparepart{}} = SparepartService.delete_sparepart(sparepart)
      assert_raise Ecto.NoResultsError, fn -> SparepartService.get_sparepart!(sparepart.id) end
    end

    test "change_sparepart/1 returns a sparepart changeset" do
      sparepart = sparepart_fixture()
      assert %Ecto.Changeset{} = SparepartService.change_sparepart(sparepart)
    end
  end
end
