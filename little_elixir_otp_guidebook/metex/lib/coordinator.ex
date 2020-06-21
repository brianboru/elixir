defmodule Metex.Coordinator do
    require IEx

    def loop(results \\ [], results_expected) do
        receive do 
            {:ok, result} ->
                new_results = [result | results]
                if results_expected == Enum.count(new_results) do
                    IEx.pry
                    send self(), :exit
                end
                loop(new_results, results_expected)
            :exit ->
                IEx.pry
                IO.puts(results |> Enum.sort |> Enum.join(", "))
            _ ->
                loop(results, results_expected)
        end
    end

end