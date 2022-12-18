defmodule AoC2022.Day18.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/18
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day

  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> count()
  end

  defp count(cubes) do
    cubes
    |> Enum.map(&(6 - connected(&1, cubes)))
    |> Enum.sum()
  end

  defp connected(cube, cubes) do
    cubes
    |> Enum.filter(&connected?(&1, cube))
    |> Enum.count()
  end

  defp connected?({x, y, z1}, {x, y, z2}), do: abs(z1 - z2) == 1
  defp connected?({x, y1, z}, {x, y2, z}), do: abs(y1 - y2) == 1
  defp connected?({x1, y, z}, {x2, y, z}), do: abs(x1 - x2) == 1
  defp connected?(x, y), do: false

  defp parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
