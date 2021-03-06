defmodule ShopifyTutorial.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias ShopifyTutorial.Repo

  alias ShopifyTutorial.Stores.Store

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    Repo.all(Store)
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id), do: Repo.get!(Store, id)

  def get_store_by_name(name), do: Repo.get_by(Store, name: name)

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    shop_name = attrs["shop"] |> String.replace(".myshopify.com", "")
    attrs = Map.merge(attrs, %{"shop" => shop_name})

    Multi.new()
    |> Multi.run(:access_token, fn _repo, _ ->
      shop_name
      |> Shopify.session()
      |> Shopify.OAuth.request_token(attrs["code"])
      |> case do
        {:ok, %{code: 200, data: %{access_token: access_token}}} ->
          {:ok, access_token}

        {:error, _} ->
          {:error, "something went wrong."}
      end
    end)
    |> Multi.insert(:store, fn %{access_token: access_token} ->
      Store.changeset(%Store{}, %{name: attrs["shop"], access_token: access_token})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{store: store}} ->
        {:ok, store}

      {:error, _, error, _} ->
        {:error, error}
    end
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:access_token, fn _repo, _ ->
      store.name
      |> Shopify.session()
      |> Shopify.OAuth.request_token(attrs["code"])
      |> case do
        {:ok, %{code: 200, data: %{access_token: access_token}}} ->
          {:ok, access_token}

        {:error, _} ->
          {:error, "something went wrong."}
      end
    end)
    |> Multi.update(:store, fn %{access_token: access_token} ->
      Store.changeset(store, %{access_token: access_token})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{store: store}} ->
        {:ok, store}

      {:error, _, error, _} ->
        {:error, error}
    end
  end

  @doc """
  Deletes a Store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{source: %Store{}}

  """
  def change_store(%Store{} = store) do
    Store.changeset(store, %{})
  end

  @spec generate_shopify_url(String.t(), String.t()) :: String.t()
  def generate_shopify_url(name, method) do
    params = %{scope: "read_content,read_products,write_products", redirect_uri: "https://localhost:4443/stores/#{method}"}

    Shopify.session(name)
    |> Shopify.OAuth.permission_url(params)
  end
end
