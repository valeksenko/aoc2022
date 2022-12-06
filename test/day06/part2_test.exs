defmodule AoC2022.Day06.Part2Test do
  use ExUnit.Case
  doctest AoC2022.Day06.Part2
  import AoC2022.Day06.Part2

  test "runs for sample input" do
    assert 19 == run(["mjqjpqmgbljsphdztnvjfqwrcgsmlb"])
    assert 29 == run(["nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"])
  end
end
