defmodule Weather.Forecast.Forecast do

    alias Weather.Coordinates.Coordinates

    def get_coordinates(city, state, country) do
        case Coordinates.call(city, state, country) do
            {:ok, coordinates} -> 
            coordinates
            {:error, :not_found} -> "url not found"
            {:error, %{}} -> "location not found"
            {:error, reason} -> reason
        end
    end

end