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
    |> (fn monkeys -> shout(monkeys[@root], monkeys) end).()
  end

  defp shout({:number, num}, _), do: num

  defp shout({:op, op, m1, m2}, monkeys) do
    with num1 <- shout(monkeys[m1], monkeys),
         num2 <- shout(monkeys[m2], monkeys),
         do: do_op(op, num1, num2)
  end

  defp do_op("+", n1, n2), do: n1 + n2
  defp do_op("-", n1, n2), do: n1 - n2
  defp do_op("*", n1, n2), do: n1 * n2
  defp do_op("/", n1, n2), do: n1 / n2
end
