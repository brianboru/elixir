defmodule MyExamples.Stack2.StackApplication do
  use Application

  def start(_type, _args) do
    {:ok, _pid} = MyExamples.Stack2.RootSupervisor.start_link([1,2,3])
  end
end
