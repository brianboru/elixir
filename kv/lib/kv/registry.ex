defmodule KV.Registry do
  use GenServer
  @moduledoc """
  Registry that manages name to pid mappings for bucket processes
  """

  # Client API

  @doc """
  Start the registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec lookup(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def lookup(registry, name) do
    GenServer.call(registry, {:lookup, name})
  end

  @spec create(atom | pid | {atom, any} | {:via, atom, any}, any) :: :ok
  def create(registry, name) do
    GenServer.cast(registry, {:create, name})
  end

  # CALLBACKS

  @impl true
  def init(:ok) do
    names = %{}
    refs = %{}

    {:ok, {names, refs}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = KV.Bucket.start_link([])
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, bucket)

      {:noreply, {names, refs}}
    end
  end

  @doc """
  Callback invoked when a monitored bucket crashes

  Here we ensure that we move the mappings from both the
  names and refs maps
  """
  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # remove the ref->name mapping from the refs map
    {name, refs} = Map.pop(refs, ref)

    # remove the name->pid mapping from the names map
    names = Map.delete(names, name)

    # new state is the new names and new refs
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
