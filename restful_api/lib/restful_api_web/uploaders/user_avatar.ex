defmodule RestfulApiWeb.Avatar do
	use Arc.Definition
	use Arc.Ecto.Definition

	@versions [:original, :thumb]
	@extension_whitelist ~w(.jpg .jpeg .gif .png)

	def validate({file, _}) do
		file_extension = file.file_name |> Path.extname |> String.downcase
		Enum.member?(@extension_whitelist, file_extension)
	end

	# def transform(:thumb, _) do
	#   {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
	# end

	# def transform(:thumb, _) do
	#   {:convert, fn(input, output) -> "inline:#{input} -format png #{output}" end, :png}
	# end

	def filename(version, _) do
		version
	end

	def storage_dir(_version, {_file, scope}) do
		"priv/static/userfiles/avatars/#{scope.id}"
	end

	# Provide a default URL if there hasn't been a file uploaded
	# def default_url(version, scope) do
	#   "/images/avatars/default_#{version}.png"
	# end
end