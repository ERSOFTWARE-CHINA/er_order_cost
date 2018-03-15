defmodule RestfulApi.ContsTest do
  use RestfulApi.DataCase

  alias RestfulApi.Conts

  describe "conts" do
    alias RestfulApi.Conts.Model.Conts

    @valid_attrs %{category: "some category", name: "some name", value: "some value"}
    @update_attrs %{category: "some updated category", name: "some updated name", value: "some updated value"}
    @invalid_attrs %{category: nil, name: nil, value: nil}

    def conts_fixture(attrs \\ %{}) do
      {:ok, conts} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Conts.create_conts()

      conts
    end

    test "list_conts/0 returns all conts" do
      conts = conts_fixture()
      assert Conts.list_conts() == [conts]
    end

    test "get_conts!/1 returns the conts with given id" do
      conts = conts_fixture()
      assert Conts.get_conts!(conts.id) == conts
    end

    test "create_conts/1 with valid data creates a conts" do
      assert {:ok, %Conts{} = conts} = Conts.create_conts(@valid_attrs)
      assert conts.category == "some category"
      assert conts.name == "some name"
      assert conts.value == "some value"
    end

    test "create_conts/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conts.create_conts(@invalid_attrs)
    end

    test "update_conts/2 with valid data updates the conts" do
      conts = conts_fixture()
      assert {:ok, conts} = Conts.update_conts(conts, @update_attrs)
      assert %Conts{} = conts
      assert conts.category == "some updated category"
      assert conts.name == "some updated name"
      assert conts.value == "some updated value"
    end

    test "update_conts/2 with invalid data returns error changeset" do
      conts = conts_fixture()
      assert {:error, %Ecto.Changeset{}} = Conts.update_conts(conts, @invalid_attrs)
      assert conts == Conts.get_conts!(conts.id)
    end

    test "delete_conts/1 deletes the conts" do
      conts = conts_fixture()
      assert {:ok, %Conts{}} = Conts.delete_conts(conts)
      assert_raise Ecto.NoResultsError, fn -> Conts.get_conts!(conts.id) end
    end

    test "change_conts/1 returns a conts changeset" do
      conts = conts_fixture()
      assert %Ecto.Changeset{} = Conts.change_conts(conts)
    end
  end
end
