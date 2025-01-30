defmodule Weather.Coordinates.Coordinates do
    def call(city, state, country) do
        url = "http://api.openweathermap.org/geo/1.0/direct?q=#{city},#{state},#{country}&limit=5&appid=9e40882d49c9fbd3c949c345aa42701f"
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                body
                |> Jason.decode!()
                |> List.first()
                |> extract_lat_lon()
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                {:error, :not_found}
            {:error, %HTTPoison.Error{reason: reason}} ->
                {:error, reason}
        end
    end
    defp extract_lat_lon(%{"lat" => lat, "lon" => lon}) do
        {:ok, %{"latitude" => lat, "longitude" => lon }}
    end
    defp extract_lat_lon(_), do: {:error, %{}}
end