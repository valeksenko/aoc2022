defmodule AoC2022.Day18.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day18.Part2
  import AoC2022.Day18.Part2
  import TestHelper

  test "runs for sample input" do
    assert 58 == run(read_example(:day18))
  end
end
