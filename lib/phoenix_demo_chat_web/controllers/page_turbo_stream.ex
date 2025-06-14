defmodule PhoenixDemoChatWeb.PageTURBO_STREAM do
  use PhoenixDemoChatWeb, :html

  def refresh(assigns) do
    ~H"""
    <.turbo_stream action="refresh" request_id={@request_id} />
    """
  end
end
