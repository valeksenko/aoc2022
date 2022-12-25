defmodule AoC2022.Day25.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day25.Part1
  import AoC2022.Day25.Part1
  import TestHelper

  test "runs for sample input" do
    assert "2=-1=0" == run(read_example(:day25))
  end
end
