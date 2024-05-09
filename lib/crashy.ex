defmodule Crashy do
  require Logger
  use GenServer

  def start(state) do
    GenServer.start(__MODULE__, state)
  end
  
  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
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

  def handle_cast({:div,n}, state) do
    1 / n
    { :noreply, state }
  end

  # senial EXIT -> {'EXIT', From, Reason}
  def handle_info({'EXIT', pid, reason}, state) do
    Logger.warn("Pid-#{inspect(pid)} :#{inspect(reason)} in handle_info")
    {:stop, reason, state}
  end

  def handle_info({:blah, pid}, state) do
    Logger.info("Recibi un mensaje de #{inspect(pid)}.")
    {:noreply, state}
  end

  ## de uso

  def terminate(reason, _state) do
    Logger.warn("#{inspect(reason)} in terminate")
  end
  
  def break(pid) do
   GenServer.cast(pid, :crash)
  end

  def blah(pid) do
    send(pid, {:blah, self})
  end
end