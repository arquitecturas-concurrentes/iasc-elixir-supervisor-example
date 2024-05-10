defmodule DynamicStack do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def start_link(state, name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  # por convencion se debe llamar child_spec
  def child_spec({name, state, restart_type}) do
    %{id: name, start: {__MODULE__, :start_link, [state, name]}, type: :worker, restart: restart_type}
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
