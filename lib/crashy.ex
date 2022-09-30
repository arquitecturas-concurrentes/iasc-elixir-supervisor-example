defmodule Crashy do
  require Logger
  use GenServer

  def start(state, name) do
    GenServer.start(__MODULE__, state, name: name)
  end
  
  def start_link(state, name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  ## Callbacks

  # es llamado por GenServer.start_link/2
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  # async
  def handle_cast(:crash, state) do
     1 / 0
    { :noreply, state }
  end

  # senial EXIT -> {'EXIT', From, Reason}
  def handle_info({'EXIT', pid, reason}, state) do
    Logger.warn("Pid-#{inspect(pid)} :#{inspect(reason)} in handle_info")
    {:stop, reason, state}
  end

  def terminate(reason, _state) do
    Logger.warn("#{inspect(reason)} in terminate")
  end
  
  def break(pid) do
   GenServer.cast(pid, :crash)
  end
end