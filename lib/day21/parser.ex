defmodule AoC2022.Day21.Parser do
  import NimbleParsec

  monkey = ascii_string([?a..?z], 4)

  operation =
    monkey
    |> ignore(string(" "))
    |> ascii_string([?+, ?-, ?*, ?/], 1)
    |> ignore(string(" "))
    |> concat(monkey)
    |> tag(:op)

  number =
    integer(min: 1)
    |> tag(:number)

  action =
    monkey
    |> ignore(string(": "))
    |> choice([
      operation,
      number
    ])
    |> eos()

  # root: pppw + sjmn
  # dbpl: 5
  defparsec(:parse, action)

  def instructions_parser(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &to_monkeys/2)
  end

  defp to_monkeys({:ok, [m, {:number, [n]}], "", _, _, _}, monkeys),
    do: Map.put(monkeys, m, {:number, n})

  defp to_monkeys({:ok, [m, {:op, [m1, op, m2]}], "", _, _, _}, monkeys),
    do: Map.put(monkeys, m, {:op, op, m1, m2})
end
