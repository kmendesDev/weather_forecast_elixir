defmodule Weathers.Repo.Migrations.StoreForecasts do
  use Ecto.Migration

  def change do
    create table(:weathers) do
      add :city, :string, null: false
      add :temp, :float
      add :temp_min, :float
      add :temp_max, :float
      add :feels_like, :float
      add :humidity, :integer
      add :pressure, :integer
      add :sunset, :utc_datetime
      add :sunrise, :utc_datetime
      add :visibility, :integer
      add :description, :string
      add :data, :utc_datetime
    end
  end
end
