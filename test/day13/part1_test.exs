defmodule AoC2022.Day13.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day13.Part1
  import AoC2022.Day13.Part1
  import TestHelper

  test "runs for sample input" do
    assert 13 == run(read_example(:day13))
  end
end
