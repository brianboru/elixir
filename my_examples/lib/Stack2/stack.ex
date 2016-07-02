defmodule MyExamples.Stack2.Stack do
  use GenServer

  ### External API
  def start_link(stash_pid) do
    {:ok, _pid} = GenServer.start(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.call(__MODULE__, {:push, item})
  end


  ### GenServer Callbacks
  ### --------------------------------------------------------------------------

  def init(stash_pid) do
    # call the stash gen server to load the state
    stack = MyExamples.Stack2.Stash.get_value stash_pid
    # return ok along with tuple containing stack and stash_pid
    # to be used as gen server state
    {:ok, {stack, stash_pid}}
  end

  @doc """
  Pops the top item off the stack
  Inbound state parameter is a tuple where the first item is a list
  and the second item in the stash pid
  """
  def handle_call(:pop, _from, {[head|tail], stash_pid}) do
    # reply with list head item and state is list tail and stash pid
    { :reply, head, {tail, stash_pid}}
  end

  def handle_call(:pop, _from, {[], stash_pid}) do
    { :reply, nil, {[], stash_pid}}
  end

  def handle_call({:push, item}, _from, {list, stash_pid}) do
    { :reply, item, {[item] ++ list, stash_pid}}
  end

  def terminate(_reason, {list, stash_pid}) do
    MyExamples.Stack2.Stash.set_value stash_pid, list
  end
end
