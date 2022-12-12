defmodule AoC2022.Day11.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day11.Part2
  import AoC2022.Day11.Part2
  import TestHelper

  test "runs for sample input" do
    assert 2_713_310_158 == run(read_example_file(:day11))
  end
end
