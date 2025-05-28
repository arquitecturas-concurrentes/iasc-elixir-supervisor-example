defmodule Crashy do
  require Logger
  use GenServer

  def start(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def start(state, name) do
    GenServer.start(__MODULE__, state, name: name)
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def start_link(state, name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  ## Callbacks

  # es llamado por GenServer.start_link/2
  def init(state) do
    {:ok, state}
  end

  # async
  def handle_cast(:crash, state) do
     _res = 1 / 0
    { :noreply, state }
  end

  def handle_cast({:div,n}, state) do
    _res = 1 / n
    { :noreply, state }
  end

  # dispatch de send
  def handle_info(:trap, state) do
    Logger.info("recibi mensaje para setear trap_exit en true")
    Process.flag(:trap_exit, true)
    {:noreply, state}
  end

  #senial EXIT -> {'EXIT', From, Reason}
  #shutdown
  def handle_info({"EXIT", pid, reason}, state) do
    Logger.warning("Pid-#{inspect(pid)} :#{inspect(reason)} in handle_info")
    {:stop, reason, state}
  end

  def handle_info({:blah, pid}, state) do
    Logger.info("Recibi un mensaje de #{inspect(pid)}.")
    {:noreply, state}
  end

  def handle_info(:parar, state) do
    Logger.info("Recibi un mensaje de parar.")
    GenServer.stop(self(), :normal)
    {:stop, :normal, state}
  end

  ## de uso

  # Callback que se llama cuando se esta por terminar el proceso de Genserver.
  def terminate(reason, _state) do
    Logger.info("#{inspect(reason)} in terminate")
  end

  def break(pid) do
   GenServer.cast(pid, :crash)
  end

  def blah(pid) do
    send(pid, {:blah, self()})
  end

  def parar(pid) do
    send(pid, :parar)
  end
end



# spawn(fn -> receive do :crash -> raise "boom" end end)

# pid = pid(0,117,0)
# Process.info(pid, :links)

# send(pid, :crash)


# {pid, ref} = spawn_monitor(fn -> receive do :crash -> raise "boom" end end)

# iex(9)> Process.info(self, :monitors)
# {:monitors, [process: #PID<0.118.0>]}

# Process.monitor(pid)

# iex(1)> {:ok, pid} = Crashy.start([], Crashy)
# {:ok, #PID<0.158.0>}
# iex(2)> pid = pid(0,156,0)
# #PID<0.158.0>
# iex(3)> Process.monitor(pid)
# #Reference<0.3021007040.111149059.36924>

# Crashy.break(pid)
