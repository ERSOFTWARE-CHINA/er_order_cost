defmodule RestfulApiWeb.UserController do
  use RestfulApiWeb, :controller
  use RestfulApi.Accounts

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, params) do
    page = page(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- save_create(User, user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_by_id(User, id, [:organization, :roles]) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, %User{} = user} <- save_update(User, id, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- delete_by_id(User, id) do
      render(conn, "show.json", user: user)
    end
  end
end
