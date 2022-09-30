defmodule SupEjemplo.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      StackSupervisor,
      %{id: StackDynamicSupervisor, start: {StackDynamicSupervisor, :start_link, [[]]} },
    ]

    #El Iasc_sup_ej.Supervisor seria el supervisor de supervisores
    opts = [strategy: :one_for_one, name: Sup_ejemplo.Supervisor, max_seconds: 5, max_restarts: 3]
    Supervisor.start_link(children, opts)
  end

end
