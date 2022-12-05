defmodule AoC2022.Day05.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day05.Part2
  import AoC2022.Day05.Part2
  import TestHelper

  test "runs for sample input" do
    assert "MCD" == run(read_example_file(:day05))
  end
end
