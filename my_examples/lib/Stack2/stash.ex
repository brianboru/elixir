defmodule MyExamples.Stack2.Stash do
  use GenServer

  ### --------------------------------------------------------------------------
  ### External API
  ### --------------------------------------------------------------------------

  def start_link(initial_stack) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, initial_stack)
  end

  def set_value(pid, stack) do
    GenServer.cast pid, {:save, stack}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  ### --------------------------------------------------------------------------
  ### GenServer Callbacks
  ### --------------------------------------------------------------------------
  def handle_call(:get_value, _from, current_stack) do
    {:reply, current_stack, current_stack}
  end

  def handle_cast({:save, stack}, _state) do
    {:noreply, stack}
  end
end
