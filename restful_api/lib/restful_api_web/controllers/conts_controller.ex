defmodule RestfulApiWeb.ContsController do
  use RestfulApiWeb, :controller

  alias RestfulApi.Conts
  alias RestfulApi.Conts.Model.Conts

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    conts = Conts.list_conts()
    render(conn, "index.json", conts: conts)
  end

  def create(conn, %{"conts" => conts_params}) do
    with {:ok, %Conts{} = conts} <- Conts.create_conts(conts_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", conts_path(conn, :show, conts))
      |> render("show.json", conts: conts)
    end
  end

  def show(conn, %{"id" => id}) do
    conts = Conts.get_conts!(id)
    render(conn, "show.json", conts: conts)
  end

  def update(conn, %{"id" => id, "conts" => conts_params}) do
    conts = Conts.get_conts!(id)

    with {:ok, %Conts{} = conts} <- Conts.update_conts(conts, conts_params) do
      render(conn, "show.json", conts: conts)
    end
  end

  def delete(conn, %{"id" => id}) do
    conts = Conts.get_conts!(id)
    with {:ok, %Conts{}} <- Conts.delete_conts(conts) do
      send_resp(conn, :no_content, "")
    end
  end
end
