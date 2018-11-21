# Since configuration is shared in umbrella projects, this file
# should only configure the :shopify_tutorial application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :shopify_tutorial, ShopifyTutorial.Repo,
  username: "postgres",
  password: "postgres",
  database: "shopify_tutorial_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
