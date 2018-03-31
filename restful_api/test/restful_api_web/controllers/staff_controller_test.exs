defmodule RestfulApiWeb.StaffControllerTest do
  use RestfulApiWeb.ConnCase

  alias RestfulApi.StaffService
  alias RestfulApi.StaffService.Staff

  @create_attrs %{age: 42, job_number: "some job_number", name: "some name", sex: "some sex"}
  @update_attrs %{age: 43, job_number: "some updated job_number", name: "some updated name", sex: "some updated sex"}
  @invalid_attrs %{age: nil, job_number: nil, name: nil, sex: nil}

  def fixture(:staff) do
    {:ok, staff} = StaffService.create_staff(@create_attrs)
    staff
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all staff", %{conn: conn} do
      conn = get conn, staff_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create staff" do
    test "renders staff when data is valid", %{conn: conn} do
      conn = post conn, staff_path(conn, :create), staff: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, staff_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "age" => 42,
        "job_number" => "some job_number",
        "name" => "some name",
        "sex" => "some sex"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, staff_path(conn, :create), staff: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update staff" do
    setup [:create_staff]

    test "renders staff when data is valid", %{conn: conn, staff: %Staff{id: id} = staff} do
      conn = put conn, staff_path(conn, :update, staff), staff: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, staff_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "age" => 43,
        "job_number" => "some updated job_number",
        "name" => "some updated name",
        "sex" => "some updated sex"}
    end

    test "renders errors when data is invalid", %{conn: conn, staff: staff} do
      conn = put conn, staff_path(conn, :update, staff), staff: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete staff" do
    setup [:create_staff]

    test "deletes chosen staff", %{conn: conn, staff: staff} do
      conn = delete conn, staff_path(conn, :delete, staff)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, staff_path(conn, :show, staff)
      end
    end
  end

  defp create_staff(_) do
    staff = fixture(:staff)
    {:ok, staff: staff}
  end
end
