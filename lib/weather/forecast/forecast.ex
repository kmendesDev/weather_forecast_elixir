defmodule Weather.Forecast.Forecast do

    alias Weather.Coordinates.Coordinates
    alias Weather.Weather
    alias Weathers.Repo

    def get_weather(city, state, country) do
        case Coordinates.call(city, state, country) do
            {:ok, coordinates} -> call_weather_api(city, coordinates)
            {:error, :not_found} -> "url not found"
            {:error, %{}} -> "location not found"
            {:error, reason} -> reason
        end
    end
    defp call_weather_api(city, %{"latitude" => lat, "longitude" => lon }) do
        url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=9e40882d49c9fbd3c949c345aa42701f"
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                body
                |> Jason.decode!()
                |> format_response(city)
                |> store_weather()
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                {:error, :not_found}
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
        time
        |> DateTime.from_unix(:second)
        |> case do 
            {:ok, datetime} -> DateTime.to_iso8601(datetime)
            _ -> nil
        end
    end
    defp store_weather(forecast) do
        %Weather{}
        |> Weather.changeset(forecast)
        |> Repo.insert()
    end
    
end