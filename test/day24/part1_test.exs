defmodule AoC2022.Day24.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day24.Part1
  import AoC2022.Day24.Part1
  import TestHelper

  test "runs for sample input" do
    assert 18 == run(read_example(:day24))
  end
end
