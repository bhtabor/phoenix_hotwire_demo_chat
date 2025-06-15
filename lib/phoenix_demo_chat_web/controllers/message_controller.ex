defmodule PhoenixDemoChatWeb.MessageController do
  use PhoenixDemoChatWeb, :controller
  plug :accepts, ["html", "turbo_stream"] when action in [:create]

  alias PhoenixDemoChat.Chat
  alias PhoenixDemoChat.Chat.Message


  def new(conn, %{"room_id" => room_id}) do
    changeset = Chat.change_message(%Message{}, %{"room_id" => room_id})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room_id" => room_id, "message" => message_params}) do
    case Chat.create_message(Map.merge(message_params, %{"room_id" => room_id})) do
      {:ok, _message} ->
        conn
        |> broadcast_room_turbo_stream_refresh(room_id)
        |> put_flash(:info, "Message created successfully.")
        |> put_status(:see_other)
        |> redirect(to: ~p"/rooms/#{room_id}")

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
    |> broadcast_room_turbo_stream_refresh(message.room_id)
    |> put_flash(:info, "Message deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/rooms/#{message.room_id}")
  end

  defp broadcast_room_turbo_stream_refresh(conn, room_id) do
    broadcast_turbo_stream_refresh(conn, "turbo_stream:room:#{room_id}")
    conn
  end
end
