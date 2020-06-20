defmodule Chapter2Exercises do
    def sum([]), do: 0
    def sum([h | t]), do: h + sum(t)

    def ex_two(list) when is_list(list) do
        list |> List.flatten |> Enum.map(fn(x) -> x*x end) |> Enum.reverse
    end
end
