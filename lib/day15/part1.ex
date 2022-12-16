defmodule AoC2022.Day15.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/15
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data), do: count(data, 2_000_000)

  def count(data, target) do
    data
    |> Enum.map(&parse/1)
    |> add_coverage(target)
    |> MapSet.size()
  end

  defp add_coverage(positions, target) do
    MapSet.difference(
      Enum.reduce(positions, MapSet.new(), &coverage(&1, &2, target)),
      Enum.reduce(positions, MapSet.new(), &add_beacon(&1, &2, target))
    )
  end

  defp coverage([sx, sy, bx, by], marked, target) do
    mark(marked, sx, distance(sx, sy, bx, by) - abs(sy - target))
  end

  defp mark(marked, _, reach) when reach < 0, do: marked

  defp mark(marked, x, reach),
    do: (x - reach)..(x + reach) |> Enum.reduce(marked, &MapSet.put(&2, &1))

  defp distance(x1, y1, x2, y2) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp add_beacon([_, _, x, y], beacons, target) when y == target, do: MapSet.put(beacons, x)
  defp add_beacon(_, beacons, _), do: beacons

  defp parse(input) do
    input
    |> String.split(~r{[^-\d]}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
