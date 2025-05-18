defmodule PhoenixHotwireDemoChat.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_hotwire_demo_chat,
    adapter: Ecto.Adapters.SQLite3
end
