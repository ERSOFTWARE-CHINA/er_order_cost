defmodule RestfulApi.BaseContext do

  import Ecto.Query, warn: false
  alias RestfulApi.Repo
  import RestfulApi.SearchTerm

  defmacro __using__(_opts) do
    quote do
      alias RestfulApi.Repo
      import RestfulApi.BaseContext
      import RestfulApi.SearchTerm
    end
  end

  def list_all(struct) do
    struct
    |> Repo.all
  end

  def get_pagination(query, params) do
    query_paginate(query, params)
  end

  def get_by_id(struct, id, preload_list \\ []) do
    struct
    |> query_preload(preload_list)
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      entity -> {:ok, entity}
    end
  end

  def get_by_name(query, field_value) do
    query
      |> Repo.get_by(field_value)
  end

  def save_create(struct, attrs) do
    struct
    |> struct(%{})
    |> struct.changeset(attrs)
    |> Repo.insert()
  end

  def save_create(changeset) do
    Repo.insert(changeset)
  end

  def save_update(struct, id, attrs) do
    struct
    |> get_by_id(id)
    |> case do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, entity} ->
        entity
        |> struct.changeset(attrs)
        |> Repo.update()
    end
  end

  def save_update(changeset) do
    Repo.update(changeset)
  end

  def delete_by_id(struct, id) do
    struct
    |> get_by_id(id)
    |> case do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, entity} -> Repo.delete(entity)
    end
  end

  def change(struct, entity) do
    struct.changeset(entity, %{})
  end
end
  