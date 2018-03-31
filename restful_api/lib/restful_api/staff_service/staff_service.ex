defmodule RestfulApi.StaffService do
  import Ecto.Query, warn: false
  use RestfulApi.BaseContext
  alias RestfulApi.StaffService.Staff

  defmacro __using__(_opts) do
    quote do
      import RestfulApi.StaffService
      use RestfulApi.BaseContext
      alias RestfulApi.StaffService.Staff
    end
  end

  def page(params, conn) do
    Staff
    |> query_like(params, "job_number")
    |> query_like(params, "name")
    |> query_like(params, "sex")
    |> query_order_by(params, "job_number")
    |> get_pagination(params, conn)
  end

  def check_job_number_exists(%{"id" => id, "job_number" => job_number}) do
    Staff
    |> Repo.get_by(job_number: job_number)
    |> case do
      nil -> {:ok, job_number}
      proj ->
        case proj.id == id do
          true -> {:ok, job_number}
          false -> {:error, job_number}
        end
    end
  end
end
