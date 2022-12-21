defmodule AoC2022.Day20.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day20.Part2
  import AoC2022.Day20.Part2
  import TestHelper

  test "runs for sample input" do
    assert 1_623_178_306 == run(read_example(:day20))
  end
end
