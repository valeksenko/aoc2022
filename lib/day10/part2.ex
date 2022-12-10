defmodule AoC2022.Day10.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/10#part2
  """
  @width 40
  @height 6

  @lit "█"
  @dark " "

  @noop :noop
  @addx :addx

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> to_program()
    |> Stream.cycle()
    |> Stream.with_index()
    |> Stream.take(@width * @height)
    |> Enum.reduce(1, &exec/2)
  end

  defp exec({op, cycle}, x) do
    col = Integer.mod(cycle, @width)

    if abs(col - x) <= 1, do: IO.binwrite(@lit), else: IO.binwrite(@dark)

    if col == @width - 1, do: IO.binwrite("\n")

    if is_integer(op), do: x + op, else: x
  end

  defp to_program(data) do
    data
    |> Enum.flat_map(&(&1 |> String.split() |> parse_op()))
  end

  defp parse_op(["noop"]), do: [@noop]
  defp parse_op(["addx", v]), do: [@addx, String.to_integer(v)]
end
