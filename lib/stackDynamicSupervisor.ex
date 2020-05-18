defmodule StackDynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(id, state) do
    #Ejemplo para agregar stack:
    #{:ok, dynamicStackUnoPid} = StackDynamicSupervisor.start_child(DynamicStackUno, [:hello])
    spec = {DynamicStack, {id, state} }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
