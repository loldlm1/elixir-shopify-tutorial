defmodule ShopifyTutorial.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string

      timestamps()
    end

    create unique_index(:stores, [:name])
  end
end
