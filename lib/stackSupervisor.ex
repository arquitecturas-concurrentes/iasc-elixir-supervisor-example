defmodule StackSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      #%{id: StackAgent, start: {StackAgent, :start_link, [[], StackAgent]}},
      %{id: Stack, start: {Stack, :start_link, [[], Stack1]}, restart: :transient},
      %{id: Stack2, start: {Stack, :start_link, [[], Stack2]}, restart: :transient},
      %{id: Stack3, start: {Stack, :start_link, [[], Stack3]}, restart: :transient},
      %{id: Stack4, start: {Stack, :start_link, [[], Stack4]}, restart: :transient},
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 5)
  end
end
