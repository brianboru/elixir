defmodule Metex.Worker do
    use GenServer

    # Client API
    def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, :ok, opts)
    end

    def get_temperature(pid, location) when is_pid(pid) do
        GenServer.call(pid, {:location, location})
    end

    # Server Callbacks
    def init(:ok) do
        {:ok, %{}}
    end

    def handle_call({:location, location}, _from, stats) do
        case temperature_of(location) do
            {:ok, temp} ->
                # new_stats = update_stats(stats, location)
                {:reply, "#{temp}C", stats}
            _ ->
                {:reply, :error, stats}
        end
        # {:reply, location, stats}
    end

    # Helper Functions - (Functional Core)
    defp temperature_of(location) do
        url_for(location) 
        |> HTTPoison.get 
        |> parse_response
    end

    defp url_for(location) do
        location = URI.encode(location)
        "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{api_key()}"
    end

    defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
        body |> JSON.decode! |> compute_temperature
    end

    defp parse_response(_) do
        IO.puts "error parsing the response"
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
    
    defp update_stats(old_stats, location) do
        case Map.has_key?(old_stats, location) do
            true ->
                Map.update!(old_stats, location, &(&1 + 1))
            false ->
                Map.put_new(old_stats, location, 1)
        end
    end
end