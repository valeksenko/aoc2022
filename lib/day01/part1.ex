defmodule AoC2022.Day01.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/1
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
  end

  defp parse(input) do
    input
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end
end
