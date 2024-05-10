defmodule Link do
  use GenServer

  def init(state) do
    IO.inspect({:init, self()})
    {:ok, state}
  end

  def handle_info({:link, link}, state) do
    Process.link(link)
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.inspect("terminate/2 callback in pid #{inspect(self())}")
    IO.inspect({:reason, reason})
    IO.inspect({:state, state})
  end
end

# {:ok, pid_1} = GenServer.start(Link, 0)
# {:ok, pid_2} = GenServer.start(Link, 0)
# send(pid_1, {:link, pid_2})
# GenServer.stop(pid_2, :reasons)