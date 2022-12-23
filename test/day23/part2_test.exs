defmodule AoC2022.Day23.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day23.Part2
  import AoC2022.Day23.Part2
  import TestHelper

  test "runs for sample input" do
    assert 20 == run(read_example(:day23))
  end
end
