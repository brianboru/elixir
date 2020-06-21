defmodule Metex.Worker do
    def loop do
        receive do
            {sender_pid, location} ->
                send(sender_pid, {:ok, temperature_of(location)})
            _ ->
                IO.puts "don't know how to process this messge"
        end
        loop()
    end
  
  defp temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}"
      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{api_key()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp compute_response(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      dir = json["wind"]["deg"]
      speed = (json["wind"]["speed"] * 2.237) |> Float.round(0)
      {:ok, temp, "#{dir} @ #{speed}"}
    rescue
      _ -> :error
    end
  end

  defp api_key do
    "cdd41fec6a1e1ebaa442ad50637f9468"
  end
end