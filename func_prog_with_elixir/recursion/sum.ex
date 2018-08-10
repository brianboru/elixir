defmodule Sum do
    def up_to(0), do: 0
    def up_to(n), do: n + up_to(n-1)

    def up_to_tail(n), do: sum_optimised(n, 0)

    defp sum_optimised(0, acc), do: acc
    defp sum_optimised(n, acc) when n > 0, do: sum_optimised(n-1, n + acc)
end