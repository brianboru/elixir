defmodule SimpleConsoleTest do
  use ExUnit.Case
  doctest SimpleConsole

  test "greets the world" do
    assert SimpleConsole.hello() == :world
  end
end
