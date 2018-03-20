defmodule RestfulApi.BaseContext do

  import Ecto.Query, warn: false
  alias RestfulApi.Repo
  alias RestfulApiWeb.Guardian
  import RestfulApi.SearchTerm

  alias RestfulApi.Tenant.Project

  defmacro __using__(_opts) do
    quote do
      alias RestfulApi.Repo
      import RestfulApi.BaseContext
      import RestfulApi.SearchTerm
    end
  end

  def list_all(struct, conn) do
    struct
    |> add_belongs_to(conn)
    |> Repo.all
  end

  def get_pagination(query, params, conn) do
    query
    |> add_belongs_to(conn)
    |> query_paginate(params)
  end

  def get_by_id(struct, id, conn, preload_list \\ []) do
    struct
    |> add_belongs_to(conn)
    |> query_preload(preload_list)
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      entity -> {:ok, entity}
    end
  end

  def get_by_name(query,  conn, field_value) do
    query
    |> add_belongs_to(conn)
    |> Repo.get_by(field_value)
  end

  def save_create(struct, attrs, conn) do
    struct
    |> struct(%{})
    |> struct.changeset(attrs)
    |> Repo.insert()
  end

  def save_create(changeset, conn) do
    IO.puts inspect changeset
    Repo.insert(changeset |> set_belongs_to(conn))
  end

  def save_update(struct, id, attrs, conn) do
    struct
    |> get_by_id(id, conn)
    |> case do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, entity} ->
        entity
        |> struct.changeset(attrs |> set_belongs_to(conn))
        |> Repo.update()
    end
  end

  def save_update(changeset, conn) do
    Repo.update(changeset |> set_belongs_to(conn))
  end

  def delete_by_id(struct, id, conn) do
    struct
    |> get_by_id(id, conn)
    |> case do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, entity} -> Repo.delete(entity)
    end
  end

  def change(struct, entity) do
    struct.changeset(entity, %{})
  end

  # 添加所属项目作为查询条件，不对root用户有效
  defp add_belongs_to(query, conn) do
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_root do
      true ->
        query
      false ->
        query 
        |> query_equal(%{ "project_id" => resource.project_id }, "project_id")
    end
  end

  defp set_belongs_to(changeset, conn) do
    IO.puts("conn is:")
    IO.puts inspect conn
    IO.puts("conn end:")
    resource = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_root do
      false ->
        project = Repo.get(Project, resource.project_id)
        project_changeset = change(Project, project)
        Ecto.Changeset.put_assoc(changeset, :project, project_changeset)
      true -> changeset
    end
  end
end
  