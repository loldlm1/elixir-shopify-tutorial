defmodule ShopifyTutorialWeb.Router do
  use ShopifyTutorialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShopifyTutorialWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/stores", StoreController, :index
    get "/stores/new", StoreController, :new
    get "/stores/create", StoreController, :create
    get "/stores/:id", StoreController, :show
    delete "/stores/:id", StoreController, :delete
    post "/create_permission_url", StoreController, :create_permission_url
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShopifyTutorialWeb do
  #   pipe_through :api
  # end
end
