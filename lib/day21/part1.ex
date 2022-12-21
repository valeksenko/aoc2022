defmodule AoC2022.Day21.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/21
  """
  import AoC2022.Day21.Parser

  @root "root"

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> instructions_parser()
    |> (fn monkeys -> shout(monkeys[@root], @root, monkeys) end).()
    |> elem(0)
  end

  defp shout({:number, num}, monkey, monkeys), do: {num, monkeys}

  defp shout({:op, op, m1, m2}, monkey, monkeys) do
    with {num1, monkeys1} <- shout(monkeys[m1], m1, monkeys),
         {num2, monkeys2} <- shout(monkeys1[m2], m2, monkeys1),
         do: {do_op(op, num1, num2), monkeys2}
  end

  defp do_op("+", n1, n2), do: n1 + n2
  defp do_op("-", n1, n2), do: n1 - n2
  defp do_op("*", n1, n2), do: n1 * n2
  defp do_op("/", n1, n2), do: n1 / n2
end
