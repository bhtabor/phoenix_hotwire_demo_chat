defmodule PhoenixHotwireDemoChatWeb.Turbo.Controller do
  import Plug.Conn, only: [get_req_header: 2]

  def broadcast_turbo_stream_refresh(conn, topic, opts \\ []) do
    request_id = if Keyword.get(opts, :debounced, true), do: get_turbo_request_id(conn), else: nil

    broadcast_turbo_stream(topic, PhoenixHotwireDemoChatWeb.Turbo.Stream, "refresh", %{
      request_id: request_id
    })
  end

  def broadcast_turbo_stream(topic, module, template, assign) do
    stream =
      Phoenix.Template.render_to_string(
        module,
        template,
        "turbo_stream",
        assign
      )

    PhoenixHotwireDemoChatWeb.Endpoint.broadcast(topic, "message", %{data: stream})
  end

  defp get_turbo_request_id(conn) do
    conn
    |> get_req_header("x-turbo-request-id")
    |> List.first()
  end
end
