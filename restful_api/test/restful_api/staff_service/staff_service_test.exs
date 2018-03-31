defmodule RestfulApi.StaffServiceTest do
  use RestfulApi.DataCase

  alias RestfulApi.StaffService

  describe "staff" do
    alias RestfulApi.StaffService.Staff

    @valid_attrs %{age: 42, job_number: "some job_number", name: "some name", sex: "some sex"}
    @update_attrs %{age: 43, job_number: "some updated job_number", name: "some updated name", sex: "some updated sex"}
    @invalid_attrs %{age: nil, job_number: nil, name: nil, sex: nil}

    def staff_fixture(attrs \\ %{}) do
      {:ok, staff} =
        attrs
        |> Enum.into(@valid_attrs)
        |> StaffService.create_staff()

      staff
    end

    test "list_staff/0 returns all staff" do
      staff = staff_fixture()
      assert StaffService.list_staff() == [staff]
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = staff_fixture()
      assert StaffService.get_staff!(staff.id) == staff
    end

    test "create_staff/1 with valid data creates a staff" do
      assert {:ok, %Staff{} = staff} = StaffService.create_staff(@valid_attrs)
      assert staff.age == 42
      assert staff.job_number == "some job_number"
      assert staff.name == "some name"
      assert staff.sex == "some sex"
    end

    test "create_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StaffService.create_staff(@invalid_attrs)
    end

    test "update_staff/2 with valid data updates the staff" do
      staff = staff_fixture()
      assert {:ok, staff} = StaffService.update_staff(staff, @update_attrs)
      assert %Staff{} = staff
      assert staff.age == 43
      assert staff.job_number == "some updated job_number"
      assert staff.name == "some updated name"
      assert staff.sex == "some updated sex"
    end

    test "update_staff/2 with invalid data returns error changeset" do
      staff = staff_fixture()
      assert {:error, %Ecto.Changeset{}} = StaffService.update_staff(staff, @invalid_attrs)
      assert staff == StaffService.get_staff!(staff.id)
    end

    test "delete_staff/1 deletes the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{}} = StaffService.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> StaffService.get_staff!(staff.id) end
    end

    test "change_staff/1 returns a staff changeset" do
      staff = staff_fixture()
      assert %Ecto.Changeset{} = StaffService.change_staff(staff)
    end
  end
end
