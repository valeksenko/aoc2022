defmodule AoC2022.Day22.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/22
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
  defp min_y(x, board), do: axis_value(board, 0, x) |> Enum.min()
  defp max_x(y, board), do: axis_value(board, 1, y) |> Enum.max()
  defp max_y(x, board), do: axis_value(board, 0, x) |> Enum.max()

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
    with dest <- destination(pos, dir, board) do
      case board[dest] do
        @empty -> {dest, dir}
        @wall -> {pos, dir}
      end
    end
  end

  defp destination({x, y}, {dx, dy}, board) when is_map_key(board, {x + dx, y + dy}),
    do: {x + dx, y + dy}

  defp destination({_, y}, @left, board), do: max_x(y, board)
  defp destination({_, y}, @right, board), do: min_x(y, board)
  defp destination({x, _}, @up, board), do: max_y(x, board)
  defp destination({x, _}, @down, board), do: min_y(x, board)
end
