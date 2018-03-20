defmodule RestfulApi.Tenant do
  @moduledoc """
  The Tenant context.
  """

  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.Tenant.Project

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.Tenant
      use RestfulApi.BaseContext
      alias RestfulApi.Tenant.Project
    end
  end

  def page(params, conn) do
    Project
    |> query_like(params, "name")
    |> query_equal(params, "actived")
    |> query_order_by(params, "name")
    |> get_pagination(params, conn)
  end

  # def save_project(Project, id, attrs, conn) do
  #   Project
  #   |> get_by_id(id, conn)
  #   |> case do
  #     {:error, :not_found} -> {:error, :not_found}
  #     {:ok, entity} ->
  #       entity
  #       |> Project.changeset(attrs)
  #       |> Repo.update()
  #   end
  # end 

end