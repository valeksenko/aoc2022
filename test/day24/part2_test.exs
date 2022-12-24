defmodule AoC2022.Day24.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day24.Part2
  import AoC2022.Day24.Part2
  import TestHelper

  test "runs for sample input" do
    assert 54 == run(read_example(:day24))
  end
end
