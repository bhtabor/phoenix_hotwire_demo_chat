defmodule PhoenixDemoChat.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    has_many :messages, PhoenixDemoChat.Chat.Message, preload_order: [desc: :id]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
