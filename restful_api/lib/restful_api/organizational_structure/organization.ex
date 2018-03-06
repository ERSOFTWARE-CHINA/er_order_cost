defmodule RestfulApi.OrganizationalStructure.Organization do
  use Ecto.Schema
  import Ecto.Changeset


  schema "organizations" do
    field :name, :string
    belongs_to :parent, RestfulApi.OrganizationalStructure.Organization, on_replace: :nilify
    has_many :children, RestfulApi.OrganizationalStructure.Organization, foreign_key: :parent_id
    has_many :users, RestfulApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end
