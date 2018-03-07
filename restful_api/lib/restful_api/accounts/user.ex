defmodule RestfulApi.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true, default: "p@ssw0rd"
    field :password_hash, :string
    field :real_name, :string
    field :position, :string
    field :is_admin, :boolean, default: false
    field :actived, :boolean, default: false
    field :perms_number, :integer, default: 0
    field :avatar, RestfulApiWeb.Avatar.Type

    many_to_many :roles, RestfulApi.Authentication.Role, join_through: "users_roles", on_replace: :delete
    belongs_to :organization, RestfulApi.OrganizationalStructure.Organization, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
      |> cast(attrs, [:name, :email, :password, :real_name, :position, :is_admin, :actived])
      |> cast_attachments(attrs, [:avatar])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> unique_constraint(:name)
      |> unique_constraint(:email)
      |> validate_length(:name, min: 2)
      |> validate_length(:password, min: 6)
      |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
