defmodule MyExamples.Stack2.RootSupervisor do
  @doc """
  This module is the root supervisor and is responsible
  for starting and monitoring the Stash GenServer and also starting
  and monitoring the supervisor for the Stack GenServer
  """
  use Supervisor

  def start_link(initial_items) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, initial_items)
    start_workers(sup, initial_items)
    result
  end

  def start_workers(sup, initial_items) do
      # start the stash gen server that will preserve state between crashes
      # of the stack implementation
      {:ok, stash} = Supervisor.start_child(sup, worker(MyExamples.Stack2.Stash, [initial_items]))

      # start the child supervisor responsible for managing the Stack
      Supervisor.start_child(sup, supervisor(MyExamples.Stack2.StackSupervisor, [stash]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
