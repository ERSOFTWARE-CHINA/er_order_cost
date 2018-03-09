defmodule RestfulApi.OrganizationalStructure do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.OrganizationalStructure.Organization
  import RestfulApi.Utils.GetTree, only: [get_tree: 1]

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.OrganizationalStructure
      use RestfulApi.BaseContext
      alias RestfulApi.OrganizationalStructure.Organization
    end
  end

  # 获取所有部门的flat列表，并按id降序排列，用以解析为树形结构
  def get_tree_list() do
    Organization
    |> list_all
    |> Enum.map(fn(e) -> Map.update!(e, :children, fn(_) -> [] end) end)
    |> Enum.sort(&(Map.get(&1, :id) >= Map.get(&2, :id)))
    |> get_tree 
  end

  def organ_exist() do
    Organization
    |> list_all
    |> case do
      [] -> false
      _ -> true
    end
  end

  

end
