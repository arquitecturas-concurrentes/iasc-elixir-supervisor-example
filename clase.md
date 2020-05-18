# Ejemplo de supervisor statico y dinamico

Para poder crear un supervisor, primero necesitamos crear un proceso hijo al que supervisar. Vamos a definir un GenServer que representa un stack:
```elixir
defmodule Stack do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  def init(stack) do
    {:ok, stack}
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end
end
```
Stack es un wrapper de una lista.  Nos permite agregar un elemento y obtenerlo usando pattern matching.

Entonces, ahora creamos un supervisor que supervise nuestro proceso Stack.

```elixir
defmodule Stack do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  def init(stack) do
    {:ok, stack}
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end
end
```
Como registramos a el proceso Stack con ese nombre, lo podemos llamar directamente así, sin obtener su pid.

```elixir
GenServer.call(Stack, :pop)
#=> :hello

GenServer.cast(Stack, {:push, :world})
#=> :ok

GenServer.call(Stack, :pop)
#=> :world
```
Sin embargo, hay un bug en nuestro Stack. Si hacemos un call :pop y el stack esta vacio, va a crashear:

```elixir
GenServer.call(Stack, :pop)
** (exit) exited in: GenServer.call(Stack, :pop, 5000)
```

Por suerte, ya que nuestro proceso esta siendo supervisado por un supervisor, este automáticamente va a restartear uno nuevo con el estado inicial de [:hello]:

```elixir
GenServer.call(Stack, :pop)
#=> :hello
```

Piensen en como solucionar ese error... una solución posible es agregar esta función al Stack, que básicamente retorna nil cuando el stack esta vacío:

```elixir
def handle_call(:pop, _from, []) do
  {:reply, nil, []}
end
```

Ademas hay un stack dinámico y un supervisor dinámico para este, notar las diferencias en como se registran y en que este último puede supervisar N DynamicStacks

```elixir
StackDynamicSupervisor.start_child(DynamicStackUno, [:hello])
StackDynamicSupervisor.start_child(DynamicStackDos, [:hello])

GenServer.call(DynamicStackUno, :pop)
#=> :hello

GenServer.call(DynamicStackUno, :pop)
#=> nil
```
