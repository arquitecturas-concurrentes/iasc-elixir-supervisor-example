defmodule SupEjemplo.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      StackSupervisor,
      %{id: StackDynamicSupervisor, start: {StackDynamicSupervisor, :start_link, [[]]} },
    ]

    #El Iasc_sup_ej.Supervisor seria el supervisor de supervisores
    opts = [strategy: :one_for_one, name: Sub_ejemplo.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
