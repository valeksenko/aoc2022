defmodule AoC2022.Day15.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day15.Part1
  import AoC2022.Day15.Part1
  import TestHelper

  test "runs for sample input" do
    assert 26 == count(read_example(:day15), 10)
  end
end
