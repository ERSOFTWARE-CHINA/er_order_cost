defmodule RestfulApi.ProductionService do
  @moduledoc """
  The ProductionService context.
  """

  import Ecto.Query, warn: false
  alias RestfulApi.Repo

  alias RestfulApi.ProductionService.Production

  @doc """
  Returns the list of prodctions.

  ## Examples

      iex> list_prodctions()
      [%Production{}, ...]

  """
  def list_prodctions do
    Repo.all(Production)
  end

  @doc """
  Gets a single production.

  Raises `Ecto.NoResultsError` if the Production does not exist.

  ## Examples

      iex> get_production!(123)
      %Production{}

      iex> get_production!(456)
      ** (Ecto.NoResultsError)

  """
  def get_production!(id), do: Repo.get!(Production, id)

  @doc """
  Creates a production.

  ## Examples

      iex> create_production(%{field: value})
      {:ok, %Production{}}

      iex> create_production(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_production(attrs \\ %{}) do
    %Production{}
    |> Production.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a production.

  ## Examples

      iex> update_production(production, %{field: new_value})
      {:ok, %Production{}}

      iex> update_production(production, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_production(%Production{} = production, attrs) do
    production
    |> Production.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Production.

  ## Examples

      iex> delete_production(production)
      {:ok, %Production{}}

      iex> delete_production(production)
      {:error, %Ecto.Changeset{}}

  """
  def delete_production(%Production{} = production) do
    Repo.delete(production)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking production changes.

  ## Examples

      iex> change_production(production)
      %Ecto.Changeset{source: %Production{}}

  """
  def change_production(%Production{} = production) do
    Production.changeset(production, %{})
  end
end
