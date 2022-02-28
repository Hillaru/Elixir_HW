defmodule MongoElixirTest do
  use ExUnit.Case
  doctest MongoElixir

  test "greets the world" do
    assert MongoElixir.hello() == :world
  end
end
