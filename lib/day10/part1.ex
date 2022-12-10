defmodule AoC2022.Day10.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/10
  """
  @log_cycles [20, 60, 100, 140, 180, 220]

  @noop :noop
  @addx :addx

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> to_program()
    |> Stream.cycle()
    |> Stream.with_index(1)
    |> Stream.take(220)
    |> Enum.reduce({[], 1}, &exec/2)
    |> elem(0)
    |> Enum.sum()
  end

  defp exec({op, cycle}, {strengths, x}) do
    {
      if(cycle in @log_cycles, do: [x * cycle | strengths], else: strengths),
      if(is_integer(op), do: x + op, else: x)
    }
  end

  defp to_program(data) do
    data
    |> Enum.flat_map(&(&1 |> String.split() |> parse_op()))
  end

  defp parse_op(["noop"]), do: [@noop]
  defp parse_op(["addx", v]), do: [@addx, String.to_integer(v)]
end
