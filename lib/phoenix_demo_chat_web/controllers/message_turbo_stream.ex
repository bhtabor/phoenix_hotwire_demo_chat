defmodule PhoenixDemoChatWeb.MessageTURBO_STREAM do
  use PhoenixDemoChatWeb, :html
  import PhoenixDemoChatWeb.MessageHTML, only: [message_form: 1]

  embed_templates "message_turbo_stream/*"
end
