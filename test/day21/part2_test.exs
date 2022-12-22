defmodule AoC2022.Day21.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day21.Part2
  import AoC2022.Day21.Part2
  import TestHelper

  test "runs for sample input" do
    assert 301 == run(read_example(:day21))
  end
end
