defmodule AoC2022.Day12.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day12.Part2
  import AoC2022.Day12.Part2
  import TestHelper

  test "runs for sample input" do
    assert 29 == run(read_example(:day12))
  end
end
