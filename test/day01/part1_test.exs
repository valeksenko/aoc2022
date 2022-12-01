defmodule AoC2022.Day01.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day01.Part1
  import AoC2022.Day01.Part1
  import TestHelper

  test "runs for sample input" do
    assert 24000 == run(read_example(:day01, false))
  end
end
