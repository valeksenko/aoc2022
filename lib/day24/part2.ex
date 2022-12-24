defmodule AoC2022.Day24.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/24#part2
  """

  @up {0, -1}
  @down {0, 1}
  @left {-1, 0}
  @right {1, 0}

  @blizzards %{
    "^" => @up,
    "v" => @down,
    "<" => @left,
    ">" => @right
  }

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> parse()
    |> forward()
    |> backward()
    |> forward()
    |> elem(1)
  end

  defp forward({{map, max_x, max_y}, total}) do
    finish = fn {pos, _} -> pos == {max_x, max_y + 1} end
    cost = fn _, {{x, y}, _} -> abs(max_x - x) + abs(max_y - y + 1) end
    # we can't estimate, so using it as a Dijkstra's
    estimated_cost = fn _, _ -> 1 end

    result =
      Astar.astar({&neighbors/1, cost, estimated_cost}, {{0, -1}, {map, max_x, max_y}}, finish)

    {result |> List.last() |> elem(1), total + length(result)}
  end

  defp backward({{map, max_x, max_y}, total}) do
    finish = fn {pos, _} -> pos == {0, -1} end
    cost = fn _, {{x, y}, _} -> x + y + 1 end
    # we can't estimate, so using it as a Dijkstra's
    estimated_cost = fn _, _ -> 1 end

    result =
      Astar.astar(
        {&neighbors/1, cost, estimated_cost},
        {{max_x, max_y + 1}, {map, max_x, max_y}},
        finish
      )

    {result |> List.last() |> elem(1), total + length(result)}
  end

  defp neighbors({pos, {map, max_x, max_y}}) do
    with updated <- update(map, max_x, max_y) do
      positions(pos)
      |> Enum.filter(&valid(&1, updated, max_x, max_y))
      |> Enum.map(&{&1, {updated, max_x, max_y}})
    end
  end

  defp positions({x, y}) do
    [
      {x, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y},
      {x - 1, y}
    ]
  end

  defp valid({x, y}, _, _, _) when y == -1, do: x == 0
  defp valid({x, y}, _, max_x, max_y) when y == max_y + 1, do: x == max_x

  defp valid({x, y}, map, max_x, max_y),
    do: x in 0..max_x and y in 0..max_y and !Map.has_key?(map, {x, y})

  defp update(map, max_x, max_y) do
    map
    |> Enum.reduce(
      %{},
      fn {pos, blizzards}, m ->
        Enum.reduce(blizzards, m, &blow(&1, &2, pos, max_x, max_y))
      end
    )
  end

  defp blow(blizzard, map, pos, max_x, max_y) do
    case {pos, @blizzards[blizzard]} do
      {{x, 0}, @up} -> add_blizzard(map, {x, max_y}, blizzard)
      {{x, ^max_y}, @down} -> add_blizzard(map, {x, 0}, blizzard)
      {{0, y}, @left} -> add_blizzard(map, {max_x, y}, blizzard)
      {{^max_x, y}, @right} -> add_blizzard(map, {0, y}, blizzard)
      _ -> add_blizzard(map, add(pos, @blizzards[blizzard]), blizzard)
    end
  end

  defp add_blizzard(map, pos, blizzard), do: Map.update(map, pos, [blizzard], &[blizzard | &1])

  defp add({x, y}, {xd, yd}), do: {x + xd, y + yd}

  defp parse(data) do
    {
      {
        data |> Enum.with_index() |> Enum.reduce(%{}, &add_row/2),
        String.length(data |> hd()) - 3,
        length(data) - 3
      },
      0
    }
  end

  defp add_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m ->
      if v in [".", "#"], do: m, else: Map.put(m, {x - 1, y - 1}, [v])
    end)
  end
end
