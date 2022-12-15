defmodule AoC2022.Day14.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/14#part2
  """
  @source {500, 0}

  @wall '#'
  @sand 'o'

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> parse()
    |> with_limits()
    |> Stream.iterate(fn {map, floor} -> pour_sand(map, floor, @source) end)
    |> Stream.drop_while(&(!Map.has_key?(elem(&1, 0), @source)))
    |> result()
  end

  defp pour_sand(map, floor, {x, y}) when not is_map_key(map, {x, y + 1}) and y + 1 < floor,
    do: pour_sand(map, floor, {x, y + 1})

  defp pour_sand(map, floor, {x, y}) when not is_map_key(map, {x - 1, y + 1}) and y + 1 < floor,
    do: pour_sand(map, floor, {x - 1, y + 1})

  defp pour_sand(map, floor, {x, y}) when not is_map_key(map, {x + 1, y + 1}) and y + 1 < floor,
    do: pour_sand(map, floor, {x + 1, y + 1})

  defp pour_sand(map, floor, pos), do: {Map.put(map, pos, @sand), floor}

  def result(steps) do
    steps
    |> Enum.take(1)
    |> hd()
    |> elem(0)
    |> Map.values()
    |> Enum.count(&(&1 == @sand))
  end

  defp with_limits(map) do
    {
      map,
      2 +
        (map
         |> Map.keys()
         |> Enum.map(&elem(&1, 1))
         |> Enum.max())
    }
  end

  defp parse(data) do
    data
    |> Enum.map(&parse_wall/1)
    |> Enum.reduce(%{}, &map_wall/2)
  end

  def map_wall(wall, map) do
    wall
    |> Enum.zip(tl(wall))
    |> Enum.reduce(map, &add_wall/2)
  end

  defp add_wall({[x1, y1], [x2, y2]}, map) do
    for(x <- x1..x2, y <- y1..y2, do: {x, y})
    |> Map.from_keys(@wall)
    |> Map.merge(map)
  end

  defp parse_wall(input) do
    input
    |> String.split(" -> ")
    |> Enum.map(fn s -> s |> String.split(",") |> Enum.map(&String.to_integer/1) end)
  end
end
