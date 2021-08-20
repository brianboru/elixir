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

  def create(registry, name) do
    GenServer.cast(registry, {:create, name})
  end

  # CALLBACKS

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @impl true
  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end

end
