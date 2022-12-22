defmodule AoC2022.Day22.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day22.Part1
  import AoC2022.Day22.Part1
  import TestHelper

  test "runs for sample input" do
    assert 6032 == run(read_example_file(:day22))
  end
end
