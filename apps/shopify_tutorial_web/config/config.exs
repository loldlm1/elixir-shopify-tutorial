# Since configuration is shared in umbrella projects, this file
# should only configure the :shopify_tutorial_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :shopify_tutorial_web,
  ecto_repos: [ShopifyTutorial.Repo],
  generators: [context_app: :shopify_tutorial]

# Configures the endpoint
config :shopify_tutorial_web, ShopifyTutorialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sCuOukLRGB0ZAQL3RCbzPfXki9UlqRziuG2PxeDzPXCwXDV/yA2xx5iJHzXpdhMN",
  render_errors: [view: ShopifyTutorialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ShopifyTutorialWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
