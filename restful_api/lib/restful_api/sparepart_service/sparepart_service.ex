defmodule RestfulApi.SparepartService do
  @moduledoc """
  The SparepartService context.
  """

  import Ecto.Query, warn: false
  alias RestfulApi.Repo

  alias RestfulApi.SparepartService.Sparepart

  @doc """
  Returns the list of spareparts.

  ## Examples

      iex> list_spareparts()
      [%Sparepart{}, ...]

  """
  def list_spareparts do
    Repo.all(Sparepart)
  end

  @doc """
  Gets a single sparepart.

  Raises `Ecto.NoResultsError` if the Sparepart does not exist.

  ## Examples

      iex> get_sparepart!(123)
      %Sparepart{}

      iex> get_sparepart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sparepart!(id), do: Repo.get!(Sparepart, id)

  @doc """
  Creates a sparepart.

  ## Examples

      iex> create_sparepart(%{field: value})
      {:ok, %Sparepart{}}

      iex> create_sparepart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sparepart(attrs \\ %{}) do
    %Sparepart{}
    |> Sparepart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sparepart.

  ## Examples

      iex> update_sparepart(sparepart, %{field: new_value})
      {:ok, %Sparepart{}}

      iex> update_sparepart(sparepart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sparepart(%Sparepart{} = sparepart, attrs) do
    sparepart
    |> Sparepart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sparepart.

  ## Examples

      iex> delete_sparepart(sparepart)
      {:ok, %Sparepart{}}

      iex> delete_sparepart(sparepart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sparepart(%Sparepart{} = sparepart) do
    Repo.delete(sparepart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sparepart changes.

  ## Examples

      iex> change_sparepart(sparepart)
      %Ecto.Changeset{source: %Sparepart{}}

  """
  def change_sparepart(%Sparepart{} = sparepart) do
    Sparepart.changeset(sparepart, %{})
  end
end
