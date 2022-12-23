defmodule AoC2022.Day23.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day23.Part1
  import AoC2022.Day23.Part1
  import TestHelper

  test "runs for sample input" do
    assert 110 == run(read_example(:day23))
  end
end
