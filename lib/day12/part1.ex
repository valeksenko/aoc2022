defmodule AoC2022.Day12.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/12
  """
  @behaviour AoC2022.Day

  @start ?S
  @finish ?E

  @impl AoC2022.Day
  def run(data) do
    data
    |> to_map()
    |> with_marks()
    |> find_path()
    |> length()
  end

  defp find_path({start, finish, map}) do
    nbs = fn pos ->
      neighbors(pos) |> Enum.reject(&ignore?(Map.get(map, pos), Map.get(map, &1)))
    end

    cost = fn _, _ -> 1 end
    # we can't estimate, so using it as a Dijkstra's
    estimated_cost = fn _, _ -> 1 end

    Astar.astar({nbs, cost, estimated_cost}, start, finish)
  end

  defp neighbors({x, y}) do
    [
      {x, y + 1},
      {x, y - 1},
      {x + 1, y},
      {x - 1, y}
    ]
  end

  defp with_marks(map) do
    {
      find_key(map, @start),
      find_key(map, @finish),
      Map.update!(map, find_key(map, @start), fn _ -> ?a end)
      |> Map.update!(find_key(map, @finish), fn _ -> ?z end)
    }
  end

  defp find_key(map, val) do
    Enum.find_value(map, fn {k, v} -> if val == v, do: k end)
  end

  def ignore?(current, neighbor) do
    is_nil(neighbor) || neighbor - current > 1
  end

  defp to_map(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &add_row/2)
  end

  defp add_row({row, y}, map) do
    row
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m -> Map.put(m, {x, y}, v) end)
  end
end
