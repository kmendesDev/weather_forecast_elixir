defmodule Weather.Weather do
    use Ecto.Schema
    import Ecto.Changeset

    schema "weathers" do
      field :city, :string
      field :temp, :float
      field :temp_min, :float
      field :temp_max, :float
      field :feels_like, :float
      field :humidity, :integer
      field :pressure, :integer
      field :sunset, :utc_datetime
      field :sunrise, :utc_datetime
      field :visibility, :integer
      field :description, :string
      field :data, :utc_datetime
    end

    def changeset(struct, params) do
        struct
        |> cast(params, [:city, :temp, :temp_min, :temp_max, :feels_like, :humidity, :pressure, :sunset, :sunrise, :visibility, :description, :data])
        |> validate_required([:city, :temp, :data])
    end
end