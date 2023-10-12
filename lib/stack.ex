defmodule Stack do
  require Logger
  use GenServer

  # punto de entrada para crear el proceso
  def start(intial_state, name) do
    GenServer.start(__MODULE__, intial_state, name: name)
  end

  def start_link(intial_state, name) do
    GenServer.start_link(__MODULE__, intial_state, name: name)
  end

  ## Callbacks
  def init(intial_state) do
    # intial_state = StackAgent.fecth_status(name)
    {:ok, intial_state}
  end

  def handle_cast(:crash, state) do
    1 / 0
   { :noreply, state }
  end

  # async
  def handle_cast({:push, head}, stack) do
    #  StackAgent.update_status(name,  [ head | stack ])
    { :noreply, [ head | stack ] }
  end

  # has to reply always
  def handle_call(:pop, _from, [head | tail]) do
    #  StackAgent.update_status(name,  tail)
    { :reply, head, tail }
  end

  def handle_call(:status, _pid, stack) do
    { :reply, stack, stack }
  end

  def terminate(reason, state) do
    Logger.warn("#{inspect(reason)} in terminate. State was #{inspect(state)}")
    #StackAgent.update(name, state)
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
