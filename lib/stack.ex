defmodule Stack do
  use GenServer

  def start_link(state, name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  ## Callbacks

  def init(stack) do
    {:ok, stack}
  end

  # async
  def handle_cast({:push, head}, stack) do
    { :noreply, [ head | stack ] }
  end

  # has to reply always
  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail}
  end

  def handle_call(:status, _pid, stack) do
    { :reply, stack, stack }
  end

  ### helpers
  def pop() do
    GenServer.call(Stack, :pop)
  end

  def stack_status() do
    GenServer.call(Stack, :status)
  end

  def push(value) do
    GenServer.cast(Stack, {:push, value})
  end
end
