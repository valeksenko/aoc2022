defmodule AoC2022.Day23.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/23#part2
  """
  @behaviour AoC2022.Day

  @northern [{0, -1}, {-1, -1}, {1, -1}]
  @southern [{0, 1}, {-1, 1}, {1, 1}]
  @western [{-1, 0}, {-1, -1}, {-1, 1}]
  @eastern [{1, 0}, {1, -1}, {1, 1}]

  @all for x <- -1..1, y <- -1..1, {x, y} != {0, 0}, do: {x, y}

  @impl AoC2022.Day
  def run(data) do
    data
    |> parse()
    |> (fn map -> {map, [@northern, @southern, @western, @eastern], []} end).()
    |> Stream.iterate(&do_round/1)
    |> Stream.with_index()
    |> Stream.drop_while(fn {{map, _, history}, _} -> map not in history end)
    |> Enum.take(1)
    |> hd()
    |> elem(1)
  end

  defp do_round({map, directions, history}) do
    map
    |> MapSet.to_list()
    |> Enum.map(&propose(&1, map, directions))
    |> move(directions, [map | history])
  end

  defp propose(pos, map, directions) do
    if free?(@all, pos, map),
      do: {pos, pos},
      else:
        Enum.find_value(directions, {pos, pos}, fn d ->
          if free?(d, pos, map), do: {position(pos, hd(d)), pos}, else: nil
        end)
  end

  defp move(proposed, directions, history) do
    {
      unique(proposed) |> MapSet.new(),
      Enum.slide(directions, 0, -1),
      history
    }
  end

  defp unique(proposed) do
    proposed
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.flat_map(fn {p, g} -> if length(g) == 1, do: [p], else: Enum.map(g, &elem(&1, 1)) end)
  end

  defp position({x, y}, {xd, yd}), do: {x + xd, y + yd}

  defp free?(check, pos, map) do
    check
    |> Enum.map(&position(pos, &1))
    |> Enum.all?(fn p -> !MapSet.member?(map, p) end)
  end

  defp parse(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), &add_row/2)
  end

  defp add_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m -> if v == "#", do: MapSet.put(m, {x, y}), else: m end)
  end
end
