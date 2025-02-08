defmodule Weather.Forecasts.Forecast do

    alias Weather.Coordinates.Coordinate
    alias Weather.Weather
    alias Weathers.Repo

    def get_forecast(city, state, country) do
        with {:ok, coordinates} <- get_coordinates(city, state, country),
             {:ok, forecast} <- call_weather_api(coordinates),
             formatted_forecast <- format_response(forecast, city),
             {:ok, weather} <- store_weather(formatted_forecast) do
                {:ok, weather}
        else
            {:error, reason} -> {:error, reason}
        end
    end
    defp get_coordinates(city, state, country) do
        case Coordinate.get_coordinates(city, state, country) do
            {:ok, coordinates} -> {:ok, coordinates}
            {:error, :not_found} -> "url not found"
            {:error, %{}} -> "location not found"
            {:error, reason} -> reason
        end
    end
    defp call_weather_api(%{"latitude" => lat, "longitude" => lon }) do
        url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=9e40882d49c9fbd3c949c345aa42701f"
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                {:ok, Jason.decode!(body)}
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                {:error, "weather data not found"}
            {:error, %HTTPoison.Error{reason: reason}} ->
                {:error, reason}
        end
    end
    defp format_response(%{
        "dt" => data,
        "main" => main,
        "sys" => sys,
        "visibility" => visibility,
        "weather" => [%{"description" => description} | _]
        }, city) do
        %{
            city: city,
            data: format_time(data),
            temp: main["temp"],
            temp_max: main["temp_max"],
            temp_min: main["temp_min"],
            feels_like: main["feels_like"],
            humidity: main["humidity"],
            pressure: main["pressure"],
            sunset: format_time(sys["sunset"]),
            sunrise: format_time(sys["sunrise"]),
            visibility: visibility,
            description: description
        } 
    end
    defp format_time(time) do
        case DateTime.from_unix(time, :second) do
            {:ok, datetime} -> DateTime.to_iso8601(datetime)
            {:error, _reason} -> nil
        end
    end
    defp store_weather(forecast) do
        %Weather{}
        |> Weather.changeset(forecast)
        |> Repo.insert()
    end
    
end