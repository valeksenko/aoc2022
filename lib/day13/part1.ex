defmodule AoC2022.Day13.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/13
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&JSON.decode!/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.filter(&right_order?/1)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.sum()
  end

  defp right_order?({[l1, l2], _}),
    do: ordered_list?(l1, l2) != {:halt, :wrong}

  defp ordered?({v1, v2}, _) when is_integer(v1) and is_integer(v2) and v1 < v2,
    do: {:halt, :right}

  defp ordered?({v1, v2}, _) when is_integer(v1) and is_integer(v2) and v1 > v2,
    do: {:halt, :wrong}

  defp ordered?({v1, v2}, _) when is_integer(v1) and is_integer(v2),
    do: {:cont, :maybe}

  defp ordered?({v1, v2}, _),
    do: ordered_list?(List.wrap(v1), List.wrap(v2))

  defp ordered_list?(l1, l2) do
    case Enum.zip(l1, l2) |> Enum.reduce_while(:maybe, &ordered?/2) do
      :maybe -> matching_lists(length(l1), length(l2))
      v -> {:halt, v}
    end
  end

  defp matching_lists(s1, s2) when s1 > s2, do: {:halt, :wrong}
  defp matching_lists(s1, s2) when s1 < s2, do: {:halt, :right}
  defp matching_lists(s1, s2) when s1 == s2, do: {:cont, :maybe}
end
