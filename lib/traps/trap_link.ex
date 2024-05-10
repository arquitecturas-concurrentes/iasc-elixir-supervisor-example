defmodule TrapLink do
  use GenServer

  @impl true
  def init(state) do
    # Trap exits
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  @impl true
  def handle_info({:link, link}, state) do
    Process.link(link)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.inspect({:handle_info, msg, state})
    {:noreply, state}
  end

  def handle_cast(:crash, state) do
    1 / 0
   { :noreply, state }
 end

  @impl true
  def terminate(reason, state) do
    IO.inspect("terminate/2 callback in pid #{inspect(self())}")
    IO.inspect({:reason, reason})
    IO.inspect({:state, state})
  end

  def break(pid) do
    GenServer.cast(pid, :crash)
   end
end

# {:ok, pid_1} = GenServer.start(TrapLink, 0)
# {:ok, pid_2} = GenServer.start(TrapLink, 0)
# send(pid_1, {:link, pid_2})
# GenServer.stop(pid_2, :normal)

# {:ok, pid_1} = GenServer.start(TrapLink, 0)
# {:ok, pid_2} = GenServer.start(TrapLink, 0)
# send(pid_1, {:link, pid_2})
# GenServer.stop(pid_2, :abnormal)