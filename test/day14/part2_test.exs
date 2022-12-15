defmodule AoC2022.Day14.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day14.Part2
  import AoC2022.Day14.Part2
  import TestHelper

  test "runs for sample input" do
    assert 93 == run(read_example(:day14))
  end
end
