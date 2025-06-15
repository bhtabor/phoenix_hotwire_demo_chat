defmodule PhoenixDemoChatWeb.MessageHTML do
  use PhoenixDemoChatWeb, :html

  embed_templates "message_html/*"

  @doc """
  Renders a message form.

  The form is defined in the template at
  message_html/message_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def message_form(assigns)
end
