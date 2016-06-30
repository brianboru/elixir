defmodule MyExamples.Stack do
  use GenServer

  ### API
  def create(list) do
    GenServer.start(MyExamples.Stack, list)
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def push(pid, item) do
    GenServer.call(pid, {:push, item})
  end

  ### Callbacks
  def handle_call(:pop, _from, [head|tail]) do
    { :reply, head, tail}
  end

  def handle_call(:pop, _from, []) do
    { :reply, nil, []}
  end

  def handle_call({:push, item}, _from, list) do
    { :reply, item, list ++ [item]}
  end



end
