defmodule StackSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      %{id: StackAgent, start: {StackAgent, :start_link, [%{}]}, restart: :permanent},
      # https://hexdocs.pm/elixir/1.14/Supervisor.html#module-restart-values-restart
      # :transient -> (default) solo restartea el proceso solo si hay un fallo
      # :temporary -> Nunca se restartean, solo la primera vez cuando se inicializa el supervisor.
      # :permanent -> siempre restartea el proceso, sin importar si fallo por un error/exception o por un stop (cerramos el proceso sin que falle)
      # %{id: Crashy, start: {Crashy, :start_link, [{}]}, restart: :transient},
      # %{id: Crashy2, start: {Crashy, :start_link, [1, Crashy2]}, restart: :temporary},
      %{id: Stack, start: {Stack, :start_link, [[], Stack1]}, restart: :permanent},
      %{id: Stack2, start: {Stack, :start_link, [[], Stack2]}, restart: :transient},
      %{id: Stack3, start: {Stack, :start_link, [[], Stack3]}, restart: :transient},
      %{id: Stack4, start: {Stack, :start_link, [[], Stack4]}, restart: :transient},
      %{id: Stack5, start: {Stack, :start_link, [[], Stack5]}, restart: :transient},
    ]

    # Politicas de estrategia de supervision
    # :one_for_one -> el proceso que falla, restartea ese.
    # :one_for_all -> si uno falla, restartea a todos que estan definidos en el arbol de supervision
    # :rest_for_one -> restartea el proceso que fallo, y todos los que se crearon despues de el al ser supervisados.
    Supervisor.init(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 5)
  end
end
