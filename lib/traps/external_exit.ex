defmodule ExternalExit do
  require Logger
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  # dispatch de send
  def handle_info(:trap, state) do
    Logger.info("recibi mensaje para setear trap_exit en true")
    Process.flag(:trap_exit, true)
    {:noreply, state}
  end

  def handle_info({:link, link}, state) do
    Logger.info("recibi link")
    Process.link(link)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.inspect({:info, msg, state})
    {:noreply, state}
  end

  @impl true
  def terminate(reason, state) do
    IO.inspect("terminate/2 callback")
    IO.inspect({:reason, reason})
    IO.inspect({:state, state})
  end

  def set_trap(pid) do
    send(pid, :trap)
  end

  def link(pid, pid_2) do
    send(pid, {:link, pid_2})
  end
end

# {:ok, pid} = GenServer.start(ExternalExit, 0)
# Process.alive?(pid)
# {:ok, pid_2} = GenServer.start(ExternalExit, 0)
# Process.exit(pid, :shutdown)
# Process.alive?(pid)

# {:ok, pid_1} = GenServer.start(ExternalExit, 0)
# {:ok, pid_2} = GenServer.start(ExternalExit, 0)