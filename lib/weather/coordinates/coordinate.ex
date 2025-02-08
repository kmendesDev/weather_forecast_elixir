defmodule Weather.Coordinates.Coordinate do
    def get_coordinates(city, state, country) do
        with {:ok, body} <- call_geo_api(city, state, country),
             body_decoded <- decode_body(body),
             {:ok, coordinates} <- extract_lat_lon(body_decoded) do
          {:ok, coordinates}
        else
          {:error, reason} -> {:error, reason}
        end
    end
    def call_geo_api(city, state, country) do
        url = "http://api.openweathermap.org/geo/1.0/direct?q=#{city},#{state},#{country}&limit=5&appid=9e40882d49c9fbd3c949c345aa42701f"
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                {:ok, body}
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                {:error, :not_found}
            {:error, %HTTPoison.Error{reason: reason}} ->
                {:error, reason}
        end
    end
    defp decode_body(body) do
        body
        |> Jason.decode!()
        |> List.first()
        #|> extract_lat_lon()
    end
    defp extract_lat_lon(%{"lat" => lat, "lon" => lon}) do
        {:ok, %{"latitude" => lat, "longitude" => lon}}
    end
    defp extract_lat_lon(_), do: {:error, %{}}
end