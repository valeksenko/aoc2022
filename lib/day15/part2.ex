defmodule AoC2022.Day15.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/15#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data), do: tuning_frequency(data, 4_000_000)

  def tuning_frequency(data, limit) do
    data
    |> Enum.map(&parse/1)
    |> find_beacon(limit)
    |> (fn {x, y} -> x * 4_000_000 + y end).()
  end

  defp find_beacon(sensors, limit) do
    Stream.flat_map(
      0..limit,
      fn x ->
        Stream.flat_map(0..limit, fn y -> [{x, y}] end)
      end
    )
    |> Stream.drop_while(&in_range?(sensors, &1))
    |> Enum.take(1)
    |> hd()
  end

  defp in_range?(sensors, pos) do
    sensors
    |> Enum.any?(fn {sensor, dist} -> distance(sensor, pos) <= dist end)
  end

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp parse(input) do
    input
    |> String.split(~r{[^-\d]}, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> (fn [sx, sy, bx, by] -> {{sx, sy}, distance({sx, sy}, {bx, by})} end).()
  end
end
