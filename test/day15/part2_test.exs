defmodule AoC2022.Day15.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day15.Part2
  import AoC2022.Day15.Part2
  import TestHelper

  test "runs for sample input" do
    assert 56_000_011 == tuning_frequency(read_example(:day15), 20)
  end
end
