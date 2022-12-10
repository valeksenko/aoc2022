defmodule TestHelper do
  def read_example_file(name) do
    File.read!("data/test/#{name}.txt")
  end

  def read_example(name, trim \\ true) do
    read_example_file(name) |> String.split("\n", trim: trim)
  end
end

ExUnit.start()
