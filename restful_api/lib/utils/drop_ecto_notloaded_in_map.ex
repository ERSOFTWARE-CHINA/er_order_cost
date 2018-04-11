defmodule RestfulApi.Utils.DropEctoNotLoaded do
	def drop_ecto_not_loaded_in_map(map) do
    vl = map 
      |> Map.to_list 
      |> Enum.map(fn({key, value}) -> 
        case match?( %Ecto.Association.NotLoaded{__field__: _,__owner__: _,__cardinality__: _}, value) do
          true -> key
          false -> nil
        end end)
      |> Enum.filter(fn(e) -> e != nil end)
    Map.drop(map, vl)
  end
  
end