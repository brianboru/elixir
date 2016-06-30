defmodule MyExamples.Sequence do
  @moduledoc """
  This is a simple server that returns the next number
  in a sequence
  """
  use GenServer

  @doc """
  Returns the next number in the sequence
  """
  def handle_call(:next_number, _from, current_number) do
    { :reply, current_number, current_number+1 }
  end

end
