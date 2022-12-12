defmodule AoC2022.Day11.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/11#part2
  """
  import AoC2022.Day11.Monkey
  import AoC2022.Day11.Parser

  @rounds 10000

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> monkey_parser()
    |> with_modulo()
    |> Stream.iterate(&do_round/1)
    |> Stream.drop(@rounds)
    |> Enum.take(1)
    |> hd()
    |> result()
  end

  defp with_modulo(monkeys) do
    {
      monkeys |> Map.values() |> Enum.map(& &1.condition) |> Enum.product(),
      monkeys
    }
  end

  defp do_round({modulo, monkeys}) do
    {
      modulo,
      Enum.reduce(0..(map_size(monkeys) - 1), monkeys, fn i, m ->
        turn(Map.fetch!(m, i), m, modulo)
      end)
    }
  end

  defp turn(monkey, monkeys, modulo) do
    monkey.items
    |> Enum.reduce(
      Map.put(
        monkeys,
        monkey.id,
        %{monkey | items: [], inspected: monkey.inspected + length(monkey.items)}
      ),
      fn item, m -> item |> worry_level(monkey) |> Integer.mod(modulo) |> throw(monkey, m) end
    )
  end

  defp worry_level(item, monkey) do
    case monkey.operation do
      {"+", "old"} -> item + item
      {"*", "old"} -> item * item
      {"+", n} -> item + n
      {"*", n} -> item * n
    end
  end

  defp throw(level, monkey, monkeys) do
    Map.update!(
      monkeys,
      if(Integer.mod(level, monkey.condition) == 0,
        do: monkey.throw_true,
        else: monkey.throw_false
      ),
      fn m -> %{m | items: m.items ++ [level]} end
    )
  end

  defp result({_, monkeys}) do
    monkeys
    |> Map.values()
    |> Enum.map(fn m -> m.inspected end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end
end
