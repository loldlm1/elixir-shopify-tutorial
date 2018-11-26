defmodule ShopifyTutorialWeb.StoreController do
  use ShopifyTutorialWeb, :controller

  alias ShopifyTutorial.Stores

  def index(conn, _params) do
    stores = Stores.list_stores()
    render(conn, "index.html", stores: stores)
  end

  def new(conn, params) do
    render(conn, "new.html", error: params["error"])
  end

  def create_permission_url(conn, %{"store" => %{"name" => name, "method" => method}}) do
    url = Stores.generate_shopify_url(name, method)

    conn
    |> redirect(external: url)
  end

  def create(conn, params) do
    case Stores.create_store(params) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully.")
        |> put_session(:store, Shopify.session(store.name, store.access_token))
        |> redirect(to: Routes.store_path(conn, :show, store))

      {:error, %Ecto.Changeset{errors: [name: {error_message, _}]}} ->
        conn
        |> put_flash(:error, "Store " <> error_message)
        |> redirect(to: Routes.store_path(conn, :new))

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: Routes.store_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    store = Stores.get_store!(id)

    case get_session(conn, :store) do
      nil ->
        url = Stores.generate_shopify_url(store.name, "update")

        conn
        |> redirect(external: url)

      session ->
        render(conn, "show.html", store: store)
    end
  end

  def edit(conn, %{"id" => id}) do
    store = Stores.get_store!(id)
    changeset = Stores.change_store(store)
    render(conn, "edit.html", store: store, changeset: changeset)
  end

  def update(conn, params) do
    shop_name = params["shop"] |> String.replace(".myshopify.com", "")
    store = Stores.get_store_by_name(shop_name)

    case Stores.update_store(store, params) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store updated successfully.")
        |> put_session(:store, Shopify.session(store.name, store.access_token))
        |> redirect(to: Routes.store_path(conn, :show, store))

      {:error, error_message} ->
        render(conn, "index.html", error: error_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    store = Stores.get_store!(id)
    {:ok, _store} = Stores.delete_store(store)

    conn
    |> put_flash(:info, "Store deleted successfully.")
    |> redirect(to: Routes.store_path(conn, :index))
  end
end
