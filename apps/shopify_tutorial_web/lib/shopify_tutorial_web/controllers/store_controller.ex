defmodule ShopifyTutorialWeb.StoreController do
  use ShopifyTutorialWeb, :controller

  alias ShopifyTutorial.Stores
  alias ShopifyTutorial.Stores.Store

  def index(conn, _params) do
    stores = Stores.list_stores()
    render(conn, "index.html", stores: stores)
  end

  def new(conn, params) do
    render(conn, "new.html", error: params["error"])
  end

  def create_permission_url(conn, %{"store" => %{"name" => name}}) do
    params = %{scope: "read_content,read_products,write_products", redirect_uri: "https://localhost:4443/stores/create"}

    url =
      Shopify.session(name)
      |> Shopify.OAuth.permission_url(params)

    conn
    |> redirect(external: url)
  end

  def create(conn, params) do
    case Stores.create_store(params) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully.")
        |> redirect(to: Routes.store_path(conn, :show, store))

      {:error, err_message} ->
        conn
        |> put_flash(:error, err_message)
        |> redirect(to: Routes.store_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    store = Stores.get_store!(id)
    render(conn, "show.html", store: store)
  end

  def edit(conn, %{"id" => id}) do
    store = Stores.get_store!(id)
    changeset = Stores.change_store(store)
    render(conn, "edit.html", store: store, changeset: changeset)
  end

  def update(conn, %{"id" => id, "store" => store_params}) do
    store = Stores.get_store!(id)

    case Stores.update_store(store, store_params) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store updated successfully.")
        |> redirect(to: Routes.store_path(conn, :show, store))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", store: store, changeset: changeset)
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
