defmodule AoC2022.Day01.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/1
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.reduce([[]], &parse/2)
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
  end

  defp parse(input, [current | parsed]) do
    if input == "", do: [[] | [current | parsed]], else: [[String.to_integer(input) | current] | parsed]
  end
end
