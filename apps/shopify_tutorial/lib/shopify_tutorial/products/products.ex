defmodule ShopifyTutorial.Products do
  @moduledoc """
  The Products context.
  """

  @spec list_products(Shopify.Session.t()) :: [Shopify.Product.t()]
  def list_products(session) do
    session
    |> Shopify.Product.all()
    |> case do
      {:ok, %Shopify.Response{code: 200, data: products}} ->
        {:ok, products}

      {:error, %Shopify.Response{code: _, data: error_message}} ->
        {:error, error_message}
    end
  end

  @spec get_product!(Shopify.Session.t(), integer()) :: {:ok, Shopify.Product.t()} | {:error, :not_found}
  def get_product!(session, id) do
    session
    |> Shopify.Product.find(id)
    |> case do
      {:ok, %Shopify.Response{code: _, data: product}} ->
        {:ok, product}

      {:error, %Shopify.Response{code: _, data: error_message}} ->
        {:error, error_message}
    end
  end

  @spec create_product(Shopify.Session.t(), Map.t()) :: {:ok, Shopify.Product.t()} | {:error, :something_went_wrong}
  def create_product(session, attrs \\ %{}) do
    attrs = Map.merge(%Shopify.Product{}, attrs)

    session
    |> Shopify.Product.create(attrs)
    |> case do
      {:ok, %Shopify.Response{code: _, data: product}} ->
        {:ok, product}

      {:error, %Shopify.Response{code: _, data: _}} ->
        {:error, :something_went_wrong}
    end
  end

  @spec update_product(Shopify.Session.t(), integer(), Map.t()) :: {:ok, Shopify.Product.t()} | {:error, :something_went_wrong}
  def update_product(session, product_id, attrs) do
    attrs = Map.merge(%Shopify.Product{}, attrs)

    session
    |> Shopify.Product.update(product_id, attrs)
    |> case do
      {:ok, %Shopify.Response{code: _, data: product}} ->
        {:ok, product}

      {:error, %Shopify.Response{code: _, data: _}} ->
        {:error, :something_went_wrong}
    end
  end

  @spec delete_product(Shopify.Session.t(), integer()) :: {:ok, Shopify.Product.t()} | {:error, :something_went_wrong}
  def delete_product(session, product_id) do
    session
    |> Shopify.Product.delete(product_id)
    |> case do
      {:ok, %Shopify.Response{code: _, data: product}} ->
        {:ok, product}

      {:error, %Shopify.Response{code: _, data: error_message}} ->
        {:error, error_message}
    end
  end
end
