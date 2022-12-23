defmodule AoC2022.Day23.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/23
  """
  @rounds 10

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
    |> (fn map -> {map, [@northern, @southern, @western, @eastern]} end).()
    |> Stream.iterate(&do_round/1)
    |> Stream.drop(@rounds)
    |> Enum.take(1)
    |> hd()
    |> elem(0)
    |> empty_grounds()
  end

  defp do_round({map, directions}) do
    map
    |> MapSet.to_list()
    |> Enum.map(&propose(&1, map, directions))
    |> move(directions)
  end

  defp propose(pos, map, directions) do
    if free?(@all, pos, map),
      do: {pos, pos},
      else:
        Enum.find_value(directions, {pos, pos}, fn d ->
          if free?(d, pos, map), do: {position(pos, hd(d)), pos}, else: nil
        end)
  end

  defp move(proposed, directions) do
    {
      unique(proposed) |> MapSet.new(),
      Enum.slide(directions, 0, -1)
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

  defp empty_grounds(positions) do
    (max_x(positions) - min_x(positions) + 1) * (max_y(positions) - min_y(positions) + 1) -
      MapSet.size(positions)
  end

  defp min_x(positions), do: axis_values(positions, 0) |> Enum.min()
  defp min_y(positions), do: axis_values(positions, 1) |> Enum.min()
  defp max_x(positions), do: axis_values(positions, 0) |> Enum.max()
  defp max_y(positions), do: axis_values(positions, 1) |> Enum.max()

  defp axis_values(positions, axis) do
    positions
    |> MapSet.to_list()
    |> Enum.map(&elem(&1, axis))
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

  # defp inspect_positions(positions) do
  #   IO.binwrite("\n")

  #   for y <- min_y(positions)..max_y(positions) do
  #     for x <- min_x(positions)..max_x(positions) do
  #       IO.binwrite(if MapSet.member?(positions, {x, y}), do: "#", else: " ")
  #     end
  #     IO.binwrite("\n")
  #   end

  #   IO.binwrite("\n")

  #   positions
  # end
end
