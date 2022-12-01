defmodule AoC2022.Day01.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/1#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.reduce([[]], &parse/2)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum
  end

  defp parse(input, [current | parsed]) do
    if input == "", do: [[] | [current | parsed]], else: [[String.to_integer(input) | current] | parsed]
  end
end
