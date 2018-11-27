defmodule ShopifyTutorialWeb.ProductController do
  use ShopifyTutorialWeb, :controller

  alias ShopifyTutorial.Products
  plug :current_session?

  def index(conn, _params) do
    case Products.list_products(current_session(conn)) do
      {:ok, products} ->
        render(conn, "index.html", products: products)

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: "/")
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"product" => product_params}) do
    case Products.create_product(current_session(conn), product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: Routes.product_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    case Products.get_product!(current_session(conn), id) do
      {:ok, product} ->
        render(conn, "show.html", product: product)

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: Routes.product_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => product_id}) do
    render(conn, "edit.html", product_id: product_id)
  end

  def update(conn, %{"id" => product_id, "product" => product_params}) do
    case Products.update_product(current_session(conn), product_id, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, error_message} ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: Routes.product_path(conn, :edit, product_id))
    end
  end

  def delete(conn, %{"id" => product_id}) do
    {:ok, _product} = Products.delete_product(current_session(conn), product_id)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end
end
