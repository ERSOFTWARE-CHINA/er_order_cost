defmodule RestfulApi.Conts do
  @moduledoc """
  The Conts context.
  """

  import Ecto.Query, warn: false
  alias RestfulApi.Repo

  alias RestfulApi.Conts.Model.Conts

  @doc """
  Returns the list of conts.

  ## Examples

      iex> list_conts()
      [%Conts{}, ...]

  """
  def list_conts do
    Repo.all(Conts)
  end

  @doc """
  Gets a single conts.

  Raises `Ecto.NoResultsError` if the Conts does not exist.

  ## Examples

      iex> get_conts!(123)
      %Conts{}

      iex> get_conts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conts!(id), do: Repo.get!(Conts, id)

  @doc """
  Creates a conts.

  ## Examples

      iex> create_conts(%{field: value})
      {:ok, %Conts{}}

      iex> create_conts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conts(attrs \\ %{}) do
    %Conts{}
    |> Conts.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conts.

  ## Examples

      iex> update_conts(conts, %{field: new_value})
      {:ok, %Conts{}}

      iex> update_conts(conts, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conts(%Conts{} = conts, attrs) do
    conts
    |> Conts.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Conts.

  ## Examples

      iex> delete_conts(conts)
      {:ok, %Conts{}}

      iex> delete_conts(conts)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conts(%Conts{} = conts) do
    Repo.delete(conts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conts changes.

  ## Examples

      iex> change_conts(conts)
      %Ecto.Changeset{source: %Conts{}}

  """
  def change_conts(%Conts{} = conts) do
    Conts.changeset(conts, %{})
  end
end
