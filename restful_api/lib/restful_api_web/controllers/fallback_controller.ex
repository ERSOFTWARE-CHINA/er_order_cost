defmodule RestfulApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use RestfulApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(RestfulApiWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(RestfulApiWeb.ErrorView, :"404")
  end

  def call(conn, {:association_error, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(RestfulApiWeb.ChangesetView, "association_error.json", msg: msg)
  end

  # def call(conn, _) do
  #   conn
  #   |> put_status(:error)
  #   |> render(RestfulApiWeb.ErrorView, :"500")
  # end
end
