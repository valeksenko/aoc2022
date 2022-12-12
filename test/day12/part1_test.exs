defmodule AoC2022.Day12.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day12.Part1
  import AoC2022.Day12.Part1
  import TestHelper

  test "runs for sample input" do
    assert 31 == run(read_example(:day12))
  end
end
