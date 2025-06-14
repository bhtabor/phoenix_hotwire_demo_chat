defmodule PhoenixDemoChatWeb.RoomControllerTest do
  use PhoenixDemoChatWeb.ConnCase

  import PhoenixDemoChat.ChatFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/rooms")
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

  describe "new room" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/rooms/new")
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @create_attrs)

      assert %{id: id} = redirected_params(conn, 303)
      assert redirected_to(conn, 303) == ~p"/rooms/#{id}"

      conn = get(conn, ~p"/rooms/#{id}")
      assert html_response(conn, 200) =~ "some name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @invalid_attrs)
      assert html_response(conn, 422) =~ "New Room"
    end
  end

  describe "show room" do
    setup [:create_room]

    test "renders form", %{conn: conn, room: room} do
      conn = get(conn, ~p"/rooms/#{room}")
      assert html_response(conn, 200) =~ "<turbo-stream-channel-source topic=\"turbo_stream:room:#{room.id}\""
      assert html_response(conn, 200) =~ room.name
    end
  end

  describe "edit room" do
    setup [:create_room]

    test "renders form for editing chosen room", %{conn: conn, room: room} do
      conn = get(conn, ~p"/rooms/#{room}/edit")
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "update room" do
    setup [:create_room]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @update_attrs)
      assert redirected_to(conn, 303) == ~p"/rooms/#{room}"

      conn = get(conn, ~p"/rooms/#{room}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @invalid_attrs)
      assert html_response(conn, 422) =~ "Edit Room"
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, ~p"/rooms/#{room}")
      assert redirected_to(conn, 303) == ~p"/rooms"

      assert_error_sent 404, fn ->
        get(conn, ~p"/rooms/#{room}")
      end
    end
  end

  defp create_room(_) do
    room = room_fixture()

    %{room: room}
  end
end
