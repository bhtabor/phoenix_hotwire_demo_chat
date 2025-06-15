defmodule PhoenixDemoChatWeb.MessageControllerTest do
  use PhoenixDemoChatWeb.ConnCase

  import PhoenixDemoChat.ChatFixtures

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

    test "redirects to show when data is valid", %{conn: conn, room: room} do
      conn = post(conn, ~p"/rooms/#{room}/messages", message: @create_attrs)
      assert redirected_to(conn, 303) == ~p"/rooms/#{room}"
    end

    test "renders errors on html request when data is invalid", %{conn: conn, room: room} do
      conn = post(conn, ~p"/rooms/#{room}/messages", message: @invalid_attrs)
      assert html_response(conn, 422) =~ "New Message"
    end

    test "renders errors on turbo stream request when data is invalid", %{conn: conn, room: room} do
      conn =
        conn
        |> put_req_header("accept", "text/vnd.turbo-stream.html, text/html")
        |> post(~p"/rooms/#{room}/messages", message: @invalid_attrs)

      assert turbo_stream_response(conn, 422) =~ "can&#39;t be blank"
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, ~p"/messages/#{message}")
      assert redirected_to(conn, 303) == ~p"/rooms/#{message.room_id}"
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
end
