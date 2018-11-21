# Since configuration is shared in umbrella projects, this file
# should only configure the :shopify_tutorial application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :shopify_tutorial,
  ecto_repos: [ShopifyTutorial.Repo]

config :shopify, [
  client_id: System.get_env("SHOPIFY_CLIENT_ID"),
  client_secret: System.get_env("SHOPIFY_CLIENT_SECRET")
]

import_config "#{Mix.env()}.exs"
