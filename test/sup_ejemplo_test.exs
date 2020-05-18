defmodule SupEjemploTest do
  use ExUnit.Case
  doctest SupEjemplo

  test "greets the world" do
    assert SupEjemplo.hello() == :world
  end
end
