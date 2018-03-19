defmodule RestfulApiWeb.OrganizationController do
  use RestfulApiWeb, :controller
  use RestfulApi.OrganizationalStructure

  action_fallback RestfulApiWeb.FallbackController

  def index(conn, _params) do
    json conn, get_tree_list(conn)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, parent_changeset} <- can_create_or_update(organization_params, conn) do
      organ_changeset = Organization.changeset(%Organization{}, organization_params)
      organ_changeset = Ecto.Changeset.put_assoc(organ_changeset, :parent, parent_changeset)
      with {:ok, %Organization{} = organization} <- save_create(organ_changeset,conn) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", organization_path(conn, :show, organization))
        |> render("show.json", organization: organization)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, organization} <- get_by_id(Organization, id, conn, [:children]) do
      render(conn, "show.json", organization: organization)
    end
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    with {:ok, organization} <- get_by_id(Organization, id, conn, [:parent]),
         {:ok, parent_changeset} <- can_create_or_update(organization_params, conn, id) do
      organ_changeset = Organization.changeset(organization, organization_params)
      organ_changeset = Ecto.Changeset.put_assoc(organ_changeset, :parent, parent_changeset)
      with {:ok, %Organization{} = organization} <- save_update(organ_changeset, conn) do
        render(conn, "show.json", organization: organization)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Organization{} = organ} <- delete_by_id(Organization, id, conn) do
      render(conn, "show.json", organization: organ)
    end
  end

  # 根据新增节点有无父节点，分别进行判断
  defp can_create_or_update(params, conn, id \\ nil) do
    params
      |> Map.get("parent", %{})
      |> Map.get("id")
      |> case do
        nil -> 
          case organ_exist(conn) do
            true ->
              case id do
                nil -> { :association_error, "Root node already exists!" }
                _ -> 
                  { :association_error, "Parent node not exists!" }
              end
            false -> { :ok, nil }
          end
        id -> 
          case get_by_id(Organization, id, conn) do
            {:error, _} -> { :association_error, "Parent node not exists!" }
            {:ok, organ} -> { :ok, change(Organization, organ) }
          end
      end
  end

end
