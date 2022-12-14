defmodule AoC2022.Day13.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day13.Part2
  import AoC2022.Day13.Part2
  import TestHelper

  test "runs for sample input" do
    assert 140 == run(read_example(:day13))
  end
end
