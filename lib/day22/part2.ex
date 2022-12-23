defmodule AoC2022.Day22.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/22#part2
  """
  import AoC2022.Day22.Parser

  @empty "."
  @wall "#"

  @left {-1, 0}
  @right {1, 0}
  @up {0, -1}
  @down {0, 1}

  @turns %{
    {"L", @left} => @down,
    {"L", @right} => @up,
    {"L", @up} => @left,
    {"L", @down} => @right,
    {"R", @left} => @up,
    {"R", @right} => @down,
    {"R", @up} => @right,
    {"R", @down} => @left
  }

  @cost %{
    @right => 0,
    @down => 1,
    @left => 2,
    @up => 3
  }

  @side 50

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    with {board, path} <- instructions_parser(data) do
      path
      |> Enum.reduce({min_x(1, board), @right}, &next(&1, &2, board))
      |> password()
    end
  end

  defp password({{x, y}, dir}), do: 1_000 * y + 4 * x + @cost[dir]

  defp min_x(y, board), do: axis_value(board, 1, y) |> Enum.min()

  defp axis_value(board, axis, val) do
    board
    |> Map.keys()
    |> Enum.filter(&(elem(&1, axis) == val))
  end

  defp next(amount, state, board) when is_integer(amount) do
    state
    |> Stream.iterate(&move(&1, board))
    |> Stream.drop(amount)
    |> Enum.take(1)
    |> hd()
  end

  defp next(turn, {pos, dir}, _), do: {pos, @turns[{turn, dir}]}

  defp move({pos, dir}, board) do
    with {dest, new_dir} <- destination(pos, dir, board) do
      case board[dest] do
        @empty -> {dest, new_dir}
        @wall -> {pos, dir}
      end
    end
  end

  defp destination({x, y}, {dx, dy}, board) when is_map_key(board, {x + dx, y + dy}),
    do: {{x + dx, y + dy}, {dx, dy}}

  # cube 1 -> 3
  defp destination({x, y}, @left, _) when x in (@side + 1)..(2 * @side) and y in 1..@side,
    do: {{1, 3 * @side + 1 - y}, @right}

  # cube 1 -> 5
  defp destination({x, y}, @up, _) when x in (@side + 1)..(2 * @side) and y in 1..@side,
    do: {{1, 2 * @side + x}, @right}

  # cube 2 -> 3
  defp destination({x, y}, @left, _)
       when x in (@side + 1)..(2 * @side) and y in (@side + 1)..(2 * @side),
       do: {{y - @side, 2 * @side + 1}, @down}

  # cube 2 -> 4
  defp destination({x, y}, @right, _)
       when x in (@side + 1)..(2 * @side) and y in (@side + 1)..(2 * @side),
       do: {{y + @side, @side}, @up}

  # cube 3 -> 1
  defp destination({x, y}, @left, _) when x in 1..@side and y in (2 * @side + 1)..(3 * @side),
    do: {{@side + 1, 3 * @side - y + 1}, @right}

  # cube 3 -> 2
  defp destination({x, y}, @up, _) when x in 1..@side and y in (2 * @side + 1)..(3 * @side),
    do: {{@side + 1, x + @side}, @right}

  # cube 4 -> 5
  defp destination({x, y}, @up, _) when x in (2 * @side + 1)..(3 * @side) and y in 1..@side,
    do: {{x - 2 * @side, 4 * @side}, @up}

  # cube 4 -> 2
  defp destination({x, y}, @down, _) when x in (2 * @side + 1)..(3 * @side) and y in 1..@side,
    do: {{2 * @side, x - @side}, @left}

  # cube 4 -> 6
  defp destination({x, y}, @right, _) when x in (2 * @side + 1)..(3 * @side) and y in 1..@side,
    do: {{2 * @side, 3 * @side - y + 1}, @left}

  # cube 5 -> 1
  defp destination({x, y}, @left, _) when x in 1..@side and y in (3 * @side + 1)..(4 * @side),
    do: {{y - 2 * @side, 1}, @down}

  # cube 5 -> 6
  defp destination({x, y}, @right, _) when x in 1..@side and y in (3 * @side + 1)..(4 * @side),
    do: {{y - 2 * @side, 3 * @side}, @up}

  # cube 5 -> 4
  defp destination({x, y}, @down, _) when x in 1..@side and y in (3 * @side + 1)..(4 * @side),
    do: {{x + 2 * @side, 1}, @down}

  # cube 6 -> 4
  defp destination({x, y}, @right, _)
       when x in (@side + 1)..(2 * @side) and y in (2 * @side + 1)..(3 * @side),
       do: {{3 * @side, 3 * @side - y + 1}, @left}

  # cube 6 -> 5
  defp destination({x, y}, @down, _)
       when x in (@side + 1)..(2 * @side) and y in (2 * @side + 1)..(3 * @side),
       do: {{@side, 2 * @side + x}, @left}
end
