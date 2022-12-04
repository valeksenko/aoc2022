defmodule AoC2022.Day04.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/4
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.count(fn [a, b] -> MapSet.subset?(a, b) || MapSet.subset?(b, a) end)
  end

  defp parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(&to_set/1)
  end

  def to_set([first, last]) do
    String.to_integer(first)..String.to_integer(last)
    |> MapSet.new()
  end
end
