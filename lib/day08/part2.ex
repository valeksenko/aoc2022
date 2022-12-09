defmodule AoC2022.Day08.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/8#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> parse
    |> scenic_scores()
    |> Map.values()
    |> Enum.max()
  end

  defp scenic_scores({trees, max_x, max_y}) do
    Enum.reduce(0..max_x, %{}, &score_cols(trees, &1, &2, max_y))
    |> (fn v -> Enum.reduce(0..max_y, v, &score_rows(trees, &1, &2, max_x)) end).()
  end

  defp score_cols(trees, x, scores, max_y) do
    1..(max_y - 1)
    |> Enum.reduce(scores, fn y, s ->
      s
      |> Map.put_new({x, y}, 1)
      |> Map.update({x, y}, 1, fn score ->
        score *
          score(trees, Map.get(trees, {x, y}), x..x, (y - 1)..0) *
          score(trees, Map.get(trees, {x, y}), x..x, (y + 1)..max_y)
      end)
    end)
  end

  defp score_rows(trees, y, scores, max_x) do
    1..(max_x - 1)
    |> Enum.reduce(scores, fn x, s ->
      s
      |> Map.put_new({x, y}, 1)
      |> Map.update({x, y}, 1, fn score ->
        score *
          score(trees, Map.get(trees, {x, y}), (x - 1)..0, y..y) *
          score(trees, Map.get(trees, {x, y}), (x + 1)..max_x, y..y)
      end)
    end)
  end

  defp score(trees, tree, xs, ys) do
    positions = for(x <- xs, y <- ys, do: {x, y})

    positions
    |> Enum.take_while(&(Map.get(trees, &1, 10) < tree))
    |> length()
    |> (fn s -> if length(positions) == s, do: s, else: s + 1 end).()
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
