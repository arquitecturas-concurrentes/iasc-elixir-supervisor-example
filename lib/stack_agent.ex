defmodule StackAgent do
  use Agent

  def start(initial_state) do
    Agent.start(fn -> initial_state end, name: __MODULE__)
  end

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def fetch_status(key) do
    Agent.get(StackAgent, &Map.get(&1, key))
  end

  # fn map -> Map.put(map, key, value) end
  def update_status(key, value) do
    Agent.update(StackAgent, &Map.put(&1, key, value))
  end
end