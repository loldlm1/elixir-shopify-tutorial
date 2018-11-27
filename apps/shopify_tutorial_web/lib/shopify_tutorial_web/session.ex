defmodule ShopifyTutorialWeb.Session do
  @moduledoc """
  Some helpers for session-related things
  """
  def current_session(conn) do
    case Plug.Conn.get_session(conn, :store) do
      nil ->
        nil

      store_session ->
        store_session
    end
  end

  def current_session?(conn, _params) do
    if !!current_session(conn) do
      conn
    else
      redirect_with_message(conn, "There's no active store session")
    end
  end

  def redirect_with_message(conn, message, path \\ "/") do
    conn
    |> Phoenix.Controller.put_flash(:info, message)
    |> Phoenix.Controller.redirect(to: path)
    |> Plug.Conn.halt()
  end
end
