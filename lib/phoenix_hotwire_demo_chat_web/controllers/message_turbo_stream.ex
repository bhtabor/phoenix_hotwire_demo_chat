defmodule PhoenixHotwireDemoChatWeb.MessageTURBO_STREAM do
  use PhoenixHotwireDemoChatWeb, :html
  import PhoenixHotwireDemoChatWeb.MessageHTML, only: [message_form: 1]

  embed_templates "message_turbo_stream/*"
end
