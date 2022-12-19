defmodule AoC2022.Day18.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/18#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day

  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> surfaces()
  end

  defp surfaces(cubes) do
    total_surfaces(cubes) - trapped_surfaces(cubes)
  end

  defp trapped_surfaces(cubes) do
    cubes
    |> Enum.map(&trapped(&1, cubes))
    |> Enum.sum()
  end

  def trapped(cube, cubes) do
    2 * Enum.count([{0, 1, 2}, {2, 0, 1}, {1, 2, 0}], &trapped?(&1, cube, cubes))
  end

  def trapped?({e1, e2, e3}, cube, cubes) do
    with v1 <- elem(cube, e1) + 1,
         v2 <- elem(cube, e2),
         v3 <- elem(cube, e3) do
      empty?({v1, v2, v3}, {e1, e2, e3}, cubes) &&
        surrounded?({v1, v2, v3}, {e1, e2, e3}, cubes) &&
        surrounded?({v3, v1, v2}, {e3, e1, e2}, cubes) &&
        surrounded?({v2, v3, v1}, {e2, e3, e1}, cubes)
    end
  end

  def surrounded?({v1, v2, v3}, {e1, e2, e3}, cubes) do
    Enum.any?(cubes, fn cube ->
      elem(cube, e1) > v1 && elem(cube, e2) == v2 && elem(cube, e3) == v3
    end) &&
      Enum.any?(cubes, fn cube ->
        elem(cube, e1) < v1 && elem(cube, e2) == v2 && elem(cube, e3) == v3
      end)
  end

  def empty?({v1, v2, v3}, {e1, e2, e3}, cubes) do
    !Enum.any?(cubes, fn cube ->
      elem(cube, e1) == v1 && elem(cube, e2) == v2 && elem(cube, e3) == v3
    end)
  end

  defp total_surfaces(cubes) do
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
  defp connected?(_, _), do: false

  defp parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
