defmodule PhoenixDemoChat.ChatTest do
  use PhoenixDemoChat.DataCase

  alias PhoenixDemoChat.Chat

  describe "rooms" do
    alias PhoenixDemoChat.Chat.Room

    import PhoenixDemoChat.ChatFixtures

    @invalid_attrs %{name: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Chat.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      message = message_fixture(%{room_id: room.id})
      assert Chat.get_room!(room.id) == room

      messages = room |> Chat.preload_messages() |> Map.get(:messages)
      assert messages == [message]
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Room{} = room} = Chat.create_room(valid_attrs)
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Room{} = room} = Chat.update_room(room, update_attrs)
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_room(room, @invalid_attrs)
      assert room == Chat.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Chat.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Chat.change_room(room)
    end
  end

  describe "messages" do
    alias PhoenixDemoChat.Chat.Message

    import PhoenixDemoChat.ChatFixtures

    @invalid_attrs %{content: nil}

    test "get_message!/1 returns the message with given id" do
      room = room_fixture()
      message = message_fixture(%{room_id: room.id})
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      room = room_fixture()
      valid_attrs = %{room_id: room.id, content: "some content"}

      assert {:ok, %Message{} = message} = Chat.create_message(valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "delete_message/1 deletes the message" do
      room = room_fixture()
      message = message_fixture(%{room_id: room.id})
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      room = room_fixture()
      message = message_fixture(%{room_id: room.id})
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end
end
