defmodule AoC2022.Day09.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day09.Part2
  import AoC2022.Day09.Part2
  import TestHelper

  test "runs for sample input" do
    assert 1 == run(read_example(:day09))
    assert 36 == run(read_example(:day09_1))
  end
end
