defmodule DynamicStack do
  use GenServer

  def start_link(name, state) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def child_spec({name, state}) do
    %{id: name, start: {__MODULE__, :start_link, [name, state]}, type: :worker, restart: :transient}
  end

  ## Callbacks

  def init(stack) do
    Process.flag(:trap_exit, true)
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

  def handle_cast(:crash, state) do
    1 / 0
   { :noreply, state }
  end

  def terminate(reason, state) do
    Logger.warn("#{inspect(reason)} in terminate. State was #{inspect(state)}")
  end

  ### helpers
  def crash(name_or_pid) do
    GenServer.call(name_or_pid, :crash)
  end

  def pop(name_or_pid) do
    GenServer.call(name_or_pid, :pop)
  end

  def stack_status(name_or_pid) do
    GenServer.call(name_or_pid, :status)
  end

  def push(name_or_pid, value) do
    GenServer.cast(name_or_pid, {:push, value})
  end
end
