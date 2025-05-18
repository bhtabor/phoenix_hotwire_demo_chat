defmodule PhoenixHotwireDemoChatWeb.Turbo.Plug do
  import Plug.Conn, only: [get_req_header: 2, assign: 3]

  def turbo_frame(conn, opts \\ []) do
    turbo_frame = get_turbo_frame(conn)

    if turbo_frame do
      assign_key = Keyword.get(opts, :assign_key, :turbo_frame)
      assign(conn, assign_key, turbo_frame)
    else
      conn
    end
  end

  defp get_turbo_frame(conn) do
    conn
    |> get_req_header("turbo-frame")
    |> List.first()
  end
end
