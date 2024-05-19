defmodule AccountManager.Account.User do
  alias AccountManager.Account.{Address, History}
  use Ecto.Schema
  import Ecto.Changeset

  @requered_fields [:username, :document, :email, :password, :phone, :profile, :is_active]

  schema "users" do
    field :username, :string
    field :document, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string
    field :profile, :string
    field :is_active, :boolean, default: true

    has_many :adresses, Address
    has_many :historys, History

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, attrs) do
    # params = %{username: "oteixeiras", document: "123456", email: "ofernandos.teixeira@gmail.com", password: "1234456", phone: "997037221", profile: "admin", is_active: true}

    user
    |> cast(attrs, @requered_fields)
    |> validate_required(@requered_fields)
    |> validate_length(:username, min: 3, max: 50)
    # |> validate_length(:document, is: 14)
    |> validate_length(:email, min: 5, max: 100)
    |> validate_format(:email, ~r/@/)
    # |> validate_length(:phone, is: 15)
    |> validate_inclusion(:profile, ["admin", "user"])
    |> add_password_hash()
  end

  defp add_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp add_password_hash(changeset), do: changeset
end
