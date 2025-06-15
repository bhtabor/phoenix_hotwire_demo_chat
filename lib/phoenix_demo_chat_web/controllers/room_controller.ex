defmodule PhoenixDemoChatWeb.RoomController do
  use PhoenixDemoChatWeb, :controller

  alias PhoenixDemoChat.Chat
  alias PhoenixDemoChat.Chat.Room

  def index(conn, _params) do
    rooms = Chat.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Chat.change_room(%Room{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Chat.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> put_status(:see_other)
        |> redirect(to: ~p"/rooms/#{room}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    render(conn, :show, room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    changeset = Chat.change_room(room)
    render(conn, :edit, room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Chat.get_room!(id)

    case Chat.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> put_status(:see_other)
        |> redirect(to: ~p"/rooms/#{room}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:edit, room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    {:ok, _room} = Chat.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/rooms")
  end
end
