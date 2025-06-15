defmodule PhoenixDemoChatWeb.MessageController do
  use PhoenixDemoChatWeb, :controller

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
    |> put_flash(:info, "Message deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/rooms/#{message.room_id}")
  end
end
