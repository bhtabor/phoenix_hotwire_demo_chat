defmodule PhoenixHotwireDemoChat.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string

    belongs_to :room, PhoenixHotwireDemoChat.Chat.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:room_id, :content])
    |> validate_required([:content])
    |> assoc_constraint(:room)
  end
end
