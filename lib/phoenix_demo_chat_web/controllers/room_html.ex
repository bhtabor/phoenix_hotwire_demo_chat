defmodule PhoenixDemoChatWeb.RoomHTML do
  use PhoenixDemoChatWeb, :html

  embed_templates "room_html/*"

  @doc """
  Renders a room form.

  The form is defined in the template at
  room_html/room_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def room_form(assigns)
end
