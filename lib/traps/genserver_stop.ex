defmodule GenServerStop do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def terminate(reason, state) do
    IO.inspect("terminate/2 callback")
    IO.inspect({:reason, reason})
    IO.inspect({:state, state})
    IO.inspect("sleep before terminating")
    Process.sleep(1_000)
    IO.inspect("really terminating")
  end
end

# {:ok, pid} = GenServer.start(GenServerStop, 0)
# GenServer.stop(pid)