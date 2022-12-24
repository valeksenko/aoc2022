defmodule AoC2022.Day21.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/21#part2
  """
  import AoC2022.Day21.Parser

  @root "root"
  @human "humn"

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> instructions_parser()
    |> human_number()
  end

  def human_number(monkeys) do
    with {:op, _, m1, m2} <- monkeys[@root] do
      case shout(monkeys[m1], m1, monkeys) do
        :defer -> shout(monkeys[m2], m2, monkeys) |> get_human(m1, monkeys[m1], monkeys)
        num -> get_human(num, m2, monkeys[m2], monkeys)
      end
    end
  end

  defp get_human(target, @human, _, _), do: target

  defp get_human(_, _, {:number, num}, _), do: num

  defp get_human(target, _, {:op, op, m1, m2}, monkeys) do
    with num1 <- shout(monkeys[m1], m1, monkeys),
         num2 <- shout(monkeys[m2], m2, monkeys),
         do: defer_op(op, {m1, num1}, {m2, num2}, target, monkeys)
  end

  defp defer_op("+", {m1, :defer}, {_, n2}, target, monkeys),
    do: get_human(target - n2, m1, monkeys[m1], monkeys)

  defp defer_op("+", {_, n1}, {m2, :defer}, target, monkeys),
    do: get_human(target - n1, m2, monkeys[m2], monkeys)

  defp defer_op("-", {m1, :defer}, {_, n2}, target, monkeys),
    do: get_human(target + n2, m1, monkeys[m1], monkeys)

  defp defer_op("-", {_, n1}, {m2, :defer}, target, monkeys),
    do: get_human(n1 - target, m2, monkeys[m2], monkeys)

  defp defer_op("*", {m1, :defer}, {_, n2}, target, monkeys),
    do: get_human(target / n2, m1, monkeys[m1], monkeys)

  defp defer_op("*", {_, n1}, {m2, :defer}, target, monkeys),
    do: get_human(target / n1, m2, monkeys[m2], monkeys)

  defp defer_op("/", {m1, :defer}, {_, n2}, target, monkeys),
    do: get_human(target * n2, m1, monkeys[m1], monkeys)

  defp defer_op("/", {_, n1}, {m2, :defer}, target, monkeys),
    do: get_human(n1 / target, m2, monkeys[m2], monkeys)

  defp shout(_, @human, _), do: :defer

  defp shout({:number, num}, _, _), do: num

  defp shout({:op, op, m1, m2}, _, monkeys) do
    with num1 <- shout(monkeys[m1], m1, monkeys),
         num2 <- shout(monkeys[m2], m2, monkeys),
         do: do_op(op, num1, num2)
  end

  defp do_op(_, :defer, _), do: :defer
  defp do_op(_, _, :defer), do: :defer

  defp do_op("+", n1, n2), do: n1 + n2
  defp do_op("-", n1, n2), do: n1 - n2
  defp do_op("*", n1, n2), do: n1 * n2
  defp do_op("/", n1, n2), do: n1 / n2
end
