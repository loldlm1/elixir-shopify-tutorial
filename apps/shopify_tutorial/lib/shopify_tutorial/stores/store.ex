defmodule ShopifyTutorial.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stores" do
    field :name, :string
    field :access_token, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :access_token])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
