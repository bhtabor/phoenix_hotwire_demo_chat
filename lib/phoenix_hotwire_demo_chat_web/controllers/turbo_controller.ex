defmodule PhoenixHotwireDemoChatWeb.TurboController do
  import Plug.Conn, only: [get_req_header: 2, assign: 3]
  alias Phoenix.{Controller, Template}

  def turbo_frame(conn, opts \\ []) do
    turbo_frame = get_turbo_frame(conn)

    if turbo_frame do
      assign_key = Keyword.get(opts, :assign_key, :turbo_frame)

      conn
      |> assign(assign_key, turbo_frame)
      |> Controller.put_layout(false)
    else
      conn
    end
  end

  defp get_turbo_frame(conn) do
    conn
    |> get_req_header("turbo-frame")
    |> List.first()
  end

  def broadcast_turbo_stream_refresh(conn, topic, opts \\ []) do
    request_id = if opts[:with_request_id], do: get_turbo_request_id(conn), else: nil
    broadcast_turbo_stream(topic, PhoenixHotwireDemoChatWeb.Turbo.TurboStream, "refresh", %{request_id: request_id})
  end

  def broadcast_turbo_stream(topic, module, template, assign) do
    stream = Template.render_to_string(
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
