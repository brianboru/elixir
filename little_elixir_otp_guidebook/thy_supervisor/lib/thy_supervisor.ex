defmodule ThySupervisor do
  use GenServer

  # API
  def start_link(child_spec_list) do
    GenServer.start_link(__MODULE__, [child_spec_list])
  end

  def start_child(supervisor, child_spec) do
    GenServer.call(supervisor, {:start_child, child_spec})
  end

  def terminate_child(supervisor, pid) when is_pid(pid) do
    GenServer.call(supervisor, {:terminate_child, pid})
  end

  def restart_start(supervisor, pid, child_spec) when is_pid(pid) do
    GenServer.call(supervisor, {:restart_child, pid, child_spec})
  end


  # Callbacks
  def init(child_spec_list) do
    Process.flag(:trap_exit, true)    # setup as a system process and receive exit notifications from child processes
    state = child_spec_list 
      |> start_children
      |> Enum.into(Map.new)

    {:ok, state}
  end

  def handle_call({:start_child, child_spec}, _from, state) do
    case start_child(child_spec) do
      {:ok, pid} ->
        new_state = state |> Map.put(pid, child_spec)
        {:reply, {:ok, pid}, new_state}
      :error ->
        {:reply, {:error, "error starting child"}, state}
      end
  end

  def handle_call({:terminate_child, pid}, _from, state) do
    case terminate_child(pid) do
      :ok ->
        new_state = state |> Map.delete(pid)
        {:reply, :ok, new_state}
      :error ->
        {:reply, {:error, "error terminating child"}, state}
  end

  def handle_call({:restart_child, pid, child_spec}, _from, state) do
    
  end

  def handle_info({:EXIT, from, :killed}, state) do
    # this looks like a duplication of the Map.delete from the handle_call :terminate callback?
    # perhaps check online
    new_state = state |> Map.delete(from)
    {:noreply, new_state}
  end

  # Private Functions
  defp start_children([child_spec|rest]) do
    case start_child(child_spec) do
      {:ok, pid} -> 
        [{pid, child_spec} | start_children(rest)]
      :error ->
        :error
    end
  end

  defp start_children([]), do: []

  defp start_child({mod, fun, args}) do
    case apply(mod, fun, args) do
      pid when is_pid(pid) ->
        Process.link(pid)
        {:ok, pid}
      _ ->
        :error
    end
  end

  defp terminate_child(pid) do
    Process.exit(pid, :kill)
    :ok
  end
end