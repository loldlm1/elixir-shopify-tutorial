defmodule ShopifyTutorialWeb.Session do
  @moduledoc """
  Some helpers for session-related things
  """
  def current_store(conn) do
    case Plug.Conn.get_session(conn, :store) do
      nil ->
        nil

      store_session ->
        store_session
    end
  end

  def logged_in?(conn), do: !!current_store(conn)
end
