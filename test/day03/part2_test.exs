defmodule AoC2022.Day03.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day03.Part2
  import AoC2022.Day03.Part2
  import TestHelper

  test "runs for sample input" do
    assert 70 == run(read_example(:day03))
  end
end
