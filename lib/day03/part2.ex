defmodule AoC2022.Day03.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/3
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.chunk_every(3)
    |> Enum.map(&diff/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.graphemes()
    |> MapSet.new()
  end

  defp diff([c1, c2, c3]) do
    MapSet.intersection(c1, c2)
    |> MapSet.intersection(c3)
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
