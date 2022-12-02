defmodule AoC2022.Day02.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day02.Part1
  import AoC2022.Day02.Part1
  import TestHelper

  test "runs for sample input" do
    assert 15 == run(read_example(:day02))
  end
end
