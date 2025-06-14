defmodule PhoenixDemoChat.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_demo_chat,
    adapter: Ecto.Adapters.SQLite3
end
