defmodule PhoenixDemoChatWeb.PageController do
  use PhoenixDemoChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
