defmodule AoC2022.Day04.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day04.Part2
  import AoC2022.Day04.Part2
  import TestHelper

  test "runs for sample input" do
    assert 4 == run(read_example(:day04))
  end
end
