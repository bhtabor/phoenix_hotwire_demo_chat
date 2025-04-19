defmodule PhoenixHotwireDemoChatWeb.MessageController do
  use PhoenixHotwireDemoChatWeb, :controller
  plug :accepts, ["html", "turbo_stream"] when action in [:create]

  alias PhoenixHotwireDemoChat.Chat
  alias PhoenixHotwireDemoChat.Chat.Message

  def new(conn, %{"room_id" => room_id}) do
    changeset = Chat.change_message(%Message{}, %{"room_id" => room_id})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room_id" => room_id, "message" => message_params}) do
    case Chat.create_message(Map.merge(message_params, %{"room_id" => room_id})) do
      {:ok, _message} ->
        turbo_frame = Map.get(conn.assigns, :turbo_frame)
        frame_id = "room-#{room_id}-new-message"

        case turbo_frame do
          ^frame_id ->
            changeset = Chat.change_message(%Message{}, %{"room_id" => room_id})
            render(conn, :new, changeset: changeset)
          _ ->
            conn
            |> put_flash(:info, "Message created successfully.")
            |> put_status(:see_other)
            |> redirect(to: ~p"/rooms/#{room_id}")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chat.get_message!(id)
    {:ok, _message} = Chat.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/rooms/#{message.room_id}")
  end
end
