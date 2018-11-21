defmodule ShopifyTutorial.Repo do
  use Ecto.Repo,
    otp_app: :shopify_tutorial,
    adapter: Ecto.Adapters.Postgres
end
