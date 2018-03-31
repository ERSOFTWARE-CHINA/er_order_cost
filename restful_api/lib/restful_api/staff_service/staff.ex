defmodule RestfulApi.StaffService.Staff do
  use Ecto.Schema
  import Ecto.Changeset


  schema "staffs" do
    field :age, :integer
    field :job_number, :string
    field :name, :string
    field :sex, :string

    belongs_to :project, RestfulApi.Tenant.Project
    timestamps()
  end

  @doc false
  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [:job_number, :name, :sex, :age])
    |> validate_required([:job_number, :name])
  end
end
