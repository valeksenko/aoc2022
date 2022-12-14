defmodule AoC2022.Day13.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/13#part2
  """
  @behaviour AoC2022.Day

  @dividers [
    [[2]],
    [[6]]
  ]

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&JSON.decode!/1)
    |> Enum.concat(@dividers)
    |> Enum.sort(&ordering/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {v, _} -> v in @dividers end)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.product()
  end

  defp ordering(l1, l2),
    do: list_ordering(l1, l2) != {:halt, :right}

  defp ordered({v1, v2}, _) when is_integer(v1) and is_integer(v2) and v1 < v2,
    do: {:halt, :left}

  defp ordered({v1, v2}, _) when is_integer(v1) and is_integer(v2) and v1 > v2,
    do: {:halt, :right}

  defp ordered({v1, v2}, _) when is_integer(v1) and is_integer(v2),
    do: {:cont, :equal}

  defp ordered({v1, v2}, _),
    do: list_ordering(List.wrap(v1), List.wrap(v2))

  defp list_ordering(l1, l2) do
    case Enum.zip(l1, l2) |> Enum.reduce_while(:equal, &ordered/2) do
      :equal -> matching_lists(length(l1), length(l2))
      v -> {:halt, v}
    end
  end

  defp matching_lists(s1, s2) when s1 > s2, do: {:halt, :right}
  defp matching_lists(s1, s2) when s1 < s2, do: {:halt, :left}
  defp matching_lists(s1, s2) when s1 == s2, do: {:cont, :equal}
end
