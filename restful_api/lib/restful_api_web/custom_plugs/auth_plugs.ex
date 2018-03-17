defmodule RestfulApiWeb.Plugs.Auth do
  use RestfulApiWeb, :controller
  import Plug.Conn
  # use Plug.Router

  alias RestfulApiWeb.Guardian

  def auth_root(conn, _) do
    {:ok, resource} = RestfulApiWeb.Guardian.Plug.current_resource(conn)
    case resource.is_root do
      true -> conn
      false -> json conn, %{error: "You are not a root user!"}
        # conn |> redirect(to: "/") |> halt()
    end
  end

  def auth_belongs_to(conn, opts) do
    conn = fetch_query_params(conn) # populates conn.params
    %{ "id" => id } = conn.params
    %{ query:  query} = opts
    %{ func: func} = opts
    IO.puts inspect id
    struct = RestfulApi.BaseContext.get_by_id(query, id)
    IO.puts inspect struct
    # module = Module.concat(App.Reporting, "name" |> String.capitalize |> String.to_atom)
    # apply(module, :func, [])
    conn
  end
end