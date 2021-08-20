defmodule KV.Bucket do
  use Agent

  @doc """
  Starts a new bucket
  """
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`
  """
  @spec get(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in to the `bucket`
  """
  @spec put(atom | pid | {atom, any} | {:via, atom, any}, any, any) :: :ok
  def put(bucket, key, value) do
    # &Map.put(&1....)
    # is short hand for
    # fn state -> Map.put(state, key, value)
    # Agent.update/3 (last arg has default value) requires a function as param 2
    # the function has a single parameter of current state and the new state will
    # be that returned by the function
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`

  Returns the current value of `key` if `key` exists
  """
  @spec delete(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
