defmodule DynamicStack do
  use GenServer

  def start_link(name, state) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def child_spec({name, state}) do
    %{id: name, start: {__MODULE__, :start_link, [name, state]}, type: :worker}
  end

  ## Callbacks

  def init(stack) do
    {:ok, stack}
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end
end
