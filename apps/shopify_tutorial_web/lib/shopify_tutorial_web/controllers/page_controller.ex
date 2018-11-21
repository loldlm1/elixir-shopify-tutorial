defmodule ShopifyTutorialWeb.PageController do
  use ShopifyTutorialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
