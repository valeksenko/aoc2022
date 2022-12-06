defmodule AoC2022.Day06.Part1Test do
  use ExUnit.Case
  doctest AoC2022.Day06.Part1
  import AoC2022.Day06.Part1

  test "runs for sample input" do
    assert 5 == run(["bvwbjplbgvbhsrlpgdmjqwftvncz"])
    assert 11 == run(["zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"])
  end
end
