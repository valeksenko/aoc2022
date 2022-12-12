defmodule AoC2022.Day11.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day11.Part1
  import AoC2022.Day11.Part1
  import TestHelper

  test "runs for sample input" do
    assert 10605 == run(read_example_file(:day11))
  end
end
