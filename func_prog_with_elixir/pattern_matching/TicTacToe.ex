defmodule TicTacToe do
    def winner({
        x, x, x,
        _, _, _,
        _, _, _
    }), do: {:winner, x}

    def winner(_board), do: {:no_winner}
end