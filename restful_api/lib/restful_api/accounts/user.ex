defmodule RestfulApi.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    # 默认密码"admin123"
    field :password_hash, :string, default: "$pbkdf2-sha512$160000$.0mu4IBJ8tD5cckQhz9tqQ$Iv05hJ49w8WqovfrVUfind8YFt.lrQpj2TNxVuSDXJ0FZHX2YMSl0l8M.FtqYoGdiZDvcTDUp/5xe4/RgkS7FQ"
    field :real_name, :string
    field :position, :string
    field :is_admin, :boolean, default: false
    field :is_root, :boolean, default: false
    field :actived, :boolean, default: false
    field :perms_number, :integer, default: 0
    field :avatar, RestfulApiWeb.Avatar.Type

    many_to_many :roles, RestfulApi.Authentication.Role, join_through: "users_roles", on_replace: :delete
    belongs_to :organization, RestfulApi.OrganizationalStructure.Organization, on_replace: :nilify
    belongs_to :project, RestfulApi.Tenant.Project, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
      |> cast(attrs, [:name, :email, :password, :real_name, :position, :is_admin, :is_root, :actived])
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
    IO.puts inspect changeset
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
