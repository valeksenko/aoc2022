defmodule AoC2022.Day17.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day17.Part1
  import AoC2022.Day17.Part1
  import TestHelper

  test "runs for sample input" do
    assert 3068 == run(read_example(:day17))
  end
end
