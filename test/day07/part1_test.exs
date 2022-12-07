defmodule AoC2022.Day07.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day07.Part1
  import AoC2022.Day07.Part1
  import TestHelper

  test "runs for sample input" do
    assert 95437 == run(read_example_file(:day07))
  end
end
