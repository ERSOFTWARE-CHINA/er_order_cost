defimpl Poison.Encoder, for: Ecto.Association.NotLoaded do
  def encode(_, _) do
    "not loaded"
  end
end
