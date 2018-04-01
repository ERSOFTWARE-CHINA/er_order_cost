defmodule RestfulApi.MaterialRequisitionServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.MaterialRequisitionService

  describe "material_requisitions" do
    alias RestfulApi.MaterialRequisitionService.MaterialRequisition

    @valid_attrs %{no: "some no"}
    @update_attrs %{no: "some updated no"}
    @invalid_attrs %{no: nil}

    def material_requisition_fixture(attrs \\ %{}) do
      {:ok, material_requisition} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MaterialRequisitionService.create_material_requisition()

      material_requisition
    end

    test "list_material_requisitions/0 returns all material_requisitions" do
      material_requisition = material_requisition_fixture()
      assert MaterialRequisitionService.list_material_requisitions() == [material_requisition]
    end

    test "get_material_requisition!/1 returns the material_requisition with given id" do
      material_requisition = material_requisition_fixture()
      assert MaterialRequisitionService.get_material_requisition!(material_requisition.id) == material_requisition
    end

    test "create_material_requisition/1 with valid data creates a material_requisition" do
      assert {:ok, %MaterialRequisition{} = material_requisition} = MaterialRequisitionService.create_material_requisition(@valid_attrs)
      assert material_requisition.no == "some no"
    end

    test "create_material_requisition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MaterialRequisitionService.create_material_requisition(@invalid_attrs)
    end

    test "update_material_requisition/2 with valid data updates the material_requisition" do
      material_requisition = material_requisition_fixture()
      assert {:ok, material_requisition} = MaterialRequisitionService.update_material_requisition(material_requisition, @update_attrs)
      assert %MaterialRequisition{} = material_requisition
      assert material_requisition.no == "some updated no"
    end

    test "update_material_requisition/2 with invalid data returns error changeset" do
      material_requisition = material_requisition_fixture()
      assert {:error, %Ecto.Changeset{}} = MaterialRequisitionService.update_material_requisition(material_requisition, @invalid_attrs)
      assert material_requisition == MaterialRequisitionService.get_material_requisition!(material_requisition.id)
    end

    test "delete_material_requisition/1 deletes the material_requisition" do
      material_requisition = material_requisition_fixture()
      assert {:ok, %MaterialRequisition{}} = MaterialRequisitionService.delete_material_requisition(material_requisition)
      assert_raise Ecto.NoResultsError, fn -> MaterialRequisitionService.get_material_requisition!(material_requisition.id) end
    end

    test "change_material_requisition/1 returns a material_requisition changeset" do
      material_requisition = material_requisition_fixture()
      assert %Ecto.Changeset{} = MaterialRequisitionService.change_material_requisition(material_requisition)
    end
  end
end
