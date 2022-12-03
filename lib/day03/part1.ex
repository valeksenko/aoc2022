defmodule AoC2022.Day03.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/3
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&diff/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split_at(round(String.length(input) / 2))
    |> Tuple.to_list()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
  end

  defp diff([c1, c2]) do
    MapSet.intersection(c1, c2)
    |> MapSet.to_list()
    |> hd()
  end

  defp priority(item) do
    item
    |> String.to_charlist()
    |> hd()
    |> letter_priority()
  end

  defp letter_priority(l) when l in ?a..?z, do: l - ?a + 1
  defp letter_priority(l) when l in ?A..?Z, do: l - ?A + 27
end
