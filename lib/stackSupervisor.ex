defmodule StackSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      %{id: Stack, start: {Stack, :start_link, [[:hola], Stack]}},
      %{id: Stack2, start: {Stack, :start_link, [[:hola], Stack2]}}
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 3, max_seconds: 5)
  end

end
