defimpl Poison.Encoder, for: Ecto.Association.NotLoaded do
  def encode(_, _) do
    "null"
  end
end

defimpl Poison.Encoder, for: Any do
  
    def encode(struct, options) do
      case is_map(struct) do
        true ->
          struct
          |> Map.from_struct
          |> sanitize_map
          |> drop_ecto_not_loaded_fields
          |> Poison.Encoder.Map.encode(options)
        false -> 
          struct
          |> Poison.Encoder.Map.encode(options)

      end
      
    end
      
    defp sanitize_map(map) do
      Map.drop(map, [:__meta__, :__struct__])
    end
  
    defp drop_ecto_not_loaded_fields(map) do
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