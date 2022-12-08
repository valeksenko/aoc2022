defmodule AoC2022.Day07.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day07.Part2
  import AoC2022.Day07.Part2
  import TestHelper

  test "runs for sample input" do
    assert 24_933_642 == run(read_example_file(:day07))
  end
end
