defmodule AoC2022.Day21.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day21.Part1
  import AoC2022.Day21.Part1
  import TestHelper

  test "runs for sample input" do
    assert 152 == run(read_example(:day21))
  end
end
