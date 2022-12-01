defmodule AoC2022.Day01.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day01.Part2
  import AoC2022.Day01.Part2
  import TestHelper

  test "runs for sample input" do
    assert 45000 == run(read_example(:day01, false))
  end
end
