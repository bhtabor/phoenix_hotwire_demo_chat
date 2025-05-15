defmodule PhoenixHotwireDemoChatWeb.MessageControllerTest do
  use PhoenixHotwireDemoChatWeb.ConnCase

  import PhoenixHotwireDemoChat.ChatFixtures
  alias Phoenix.Socket.Broadcast

  @create_attrs %{content: "some content"}
  @invalid_attrs %{content: nil}

  describe "new message" do
    setup [:create_room]

    test "renders form", %{conn: conn, room: room} do
      conn = get(conn, ~p"/rooms/#{room}/messages/new")
      assert html_response(conn, 200) =~ "New Message"
    end
  end

  describe "create message" do
    setup [:create_room]

    test "broadcasts without debouncing and redirects to show on html request when data is valid", %{conn: conn, room: room} do
      topic = subscribe_room_turbo_stream(room.id)

      conn = post(conn, ~p"/rooms/#{room}/messages", message: @create_attrs)

      assert_receive %Broadcast{event: "message", topic: ^topic, payload: %{data: stream}}
      assert stream =~ "<turbo-stream action=\"refresh\">"

      assert redirected_to(conn, 303) == ~p"/rooms/#{room}"
    end

    test "broadcasts without debouncing and renders new on turbo stream request when data is valid", %{conn: conn, room: room} do
      topic = subscribe_room_turbo_stream(room.id)

      conn =
        conn
        |> put_req_header("accept", "text/vnd.turbo-stream.html, text/html")
        |> put_req_header("x-turbo-request-id", "turbo-request-id")
        |> post(~p"/rooms/#{room}/messages", message: @create_attrs)

      assert_receive %Broadcast{event: "message", topic: ^topic, payload: %{data: stream}}
      assert stream =~ "<turbo-stream action=\"refresh\">"

      assert turbo_stream_response(conn, 200) =~ "Save Message"
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = post(conn, ~p"/rooms/#{room}/messages", message: @invalid_attrs)
      assert html_response(conn, 422) =~ "New Message"
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message and broadcasts with debouncing", %{conn: conn, message: message} do
      topic = subscribe_room_turbo_stream(message.room_id)

      conn =
        conn
        |> put_req_header("x-turbo-request-id", "turbo-request-id")
        |> delete(~p"/messages/#{message}")

      assert_receive %Broadcast{event: "message", topic: ^topic, payload: %{data: stream}}
      assert stream =~ "<turbo-stream action=\"refresh\" request-id=\"turbo-request-id\">"

      assert redirected_to(conn, 303) == ~p"/rooms/#{message.room_id}"

      assert_error_sent 404, fn ->
        delete(conn, ~p"/messages/#{message}")
      end
    end
  end

  defp create_room(_) do
    room = room_fixture()

    %{room: room}
  end

  defp create_message(_) do
    room = room_fixture()
    message = message_fixture(%{room_id: room.id})

    %{message: message}
  end

  defp subscribe_room_turbo_stream(room_id) do
    topic = "turbo_stream:room:#{room_id}"
    PhoenixHotwireDemoChatWeb.Endpoint.subscribe(topic)

    topic
  end
end
