defmodule PhoenixDemoChat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
