defmodule AoC2022.Day05.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day05.Part1
  import AoC2022.Day05.Part1
  import TestHelper

  test "runs for sample input" do
    assert "CMZ" == run(read_example_file(:day05))
  end
end
