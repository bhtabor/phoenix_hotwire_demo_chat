defmodule PhoenixHotwireDemoChatWeb.PageController do
  use PhoenixHotwireDemoChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
