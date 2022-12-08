defmodule AoC2022.Day08.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/8
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> parse
    |> all_visible
    |> MapSet.size()
  end

  defp all_visible({trees, max_x, max_y}) do
    Enum.reduce(0..max_x, MapSet.new(), &visible_cols(trees, &1, &2, max_y))
    |> (fn v -> Enum.reduce(0..max_y, v, &visible_rows(trees, &1, &2, max_x)) end).()
  end

  defp visible_cols(trees, x, visible, max_y) do
    0..max_y
    |> Enum.reduce(visible, fn y, v ->
      if visible?(trees, Map.get(trees, {x, y}), x..x, -1..(y - 1)) ||
           visible?(trees, Map.get(trees, {x, y}), x..x, (y + 1)..(max_y + 1)),
         do: MapSet.put(v, {x, y}),
         else: v
    end)
  end

  defp visible_rows(trees, y, visible, max_x) do
    0..max_x
    |> Enum.reduce(visible, fn x, v ->
      if visible?(trees, Map.get(trees, {x, y}), -1..(x - 1), y..y) ||
           visible?(trees, Map.get(trees, {x, y}), (x + 1)..(max_x + 1), y..y),
         do: MapSet.put(v, {x, y}),
         else: v
    end)
  end

  defp visible?(trees, tree, xs, ys) do
    for(x <- xs, y <- ys, do: {x, y})
    |> Enum.all?(&(Map.get(trees, &1, -1) < tree))
  end

  defp parse(data) do
    {
      data |> Enum.with_index() |> Enum.reduce(%{}, &add_row/2),
      String.length(data |> hd()) - 1,
      length(data) - 1
    }
  end

  defp add_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m -> Map.put(m, {x, y}, String.to_integer(v)) end)
  end
end
