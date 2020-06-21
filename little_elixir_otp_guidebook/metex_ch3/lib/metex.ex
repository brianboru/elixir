defmodule Metex do
  require IEx
  @moduledoc """
  Documentation for `Metex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metex.hello()
      :world

  """
  def hello do
    :world
  end

  def temperatures_of(cities) do
    c_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])
    cities |> Enum.each(fn city ->
        w_pid = spawn(Metex.Worker, :loop, [])
        send w_pid, {c_pid, city}
    end)
  end

  def cities(), do: ["Singapore", "London", "Dublin", "Cork", "Paris"]
end
