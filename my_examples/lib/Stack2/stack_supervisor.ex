defmodule MyExamples.Stack2.StackSupervisor do
  @doc """
  Supervisor to monitor the behaviour of the Stack and restart
  if it crashes
  """
  use Supervisor

  def start_link(stash_pid) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, stash_pid)
  end

  def init(stash_pid) do
    child_processes = [ worker(MyExamples.Stack2.Stack, [stash_pid])]
    supervise child_processes, strategy: :one_for_one
  end
end
