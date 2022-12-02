defmodule AoC2022.Day01.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/1#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
