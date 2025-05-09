defmodule PhoenixHotwireDemoChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:room_id])
  end
end
