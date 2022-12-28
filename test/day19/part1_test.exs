defmodule AoC2022.Day19.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day19.Part1
  import AoC2022.Day19.Part1
  import TestHelper

  test "runs for sample input" do
    assert 33 == run(read_example(:day19))
  end
end
