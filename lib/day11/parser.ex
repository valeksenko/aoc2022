defmodule AoC2022.Day11.Parser do
  import NimbleParsec

  alias AoC2022.Day11.Monkey

  new_line = ascii_string([?\n], 1)
  whitespaces = ascii_string([?\s], min: 1)

  throw_false =
    ignore(whitespaces)
    |> ignore(string("If false: throw to monkey "))
    |> integer(min: 1)
    |> ignore(new_line)
    |> tag(:throw_false)

  throw_true =
    ignore(whitespaces)
    |> ignore(string("If true: throw to monkey "))
    |> integer(min: 1)
    |> ignore(new_line)
    |> tag(:throw_true)

  condition =
    ignore(whitespaces)
    |> ignore(string("Test: divisible by "))
    |> integer(min: 1)
    |> ignore(new_line)
    |> tag(:condition)

  operation =
    ignore(whitespaces)
    |> ignore(string("Operation: new = old "))
    |> ascii_string([?+, ?*], 1)
    |> ignore(whitespaces)
    |> choice([
      integer(min: 1),
      string("old")
    ])
    |> reduce({List, :to_tuple, []})
    |> ignore(new_line)
    |> tag(:operation)

  items =
    ignore(whitespaces)
    |> ignore(string("Starting items: "))
    |> times(
      integer(min: 1)
      |> ignore(optional(string(", "))),
      min: 1
    )
    |> ignore(new_line)
    |> tag(:items)

  monkey =
    ignore(string("Monkey "))
    |> integer(min: 1)
    |> ignore(string(":\n"))
    |> concat(items)
    |> concat(operation)
    |> concat(condition)
    |> concat(throw_true)
    |> concat(throw_false)
    |> ignore(optional(new_line))
    |> tag(:monkey)

  monkeys =
    times(
      monkey,
      min: 1
    )
    |> eos()

  defparsec(:parse, monkeys)

  def monkey_parser(data) do
    case parse(data) do
      {:ok, parsed, "", _, _, _} ->
        parsed
        |> Enum.map(&to_monkey/1)
        |> Enum.reduce(%{}, fn m, all -> Map.put(all, m.id, m) end)
    end
  end

  defp to_monkey(
         {:monkey,
          [
            id,
            {:items, items},
            {:operation, [operation]},
            {:condition, [condition]},
            {:throw_true, [throw_true]},
            {:throw_false, [throw_false]}
          ]}
       ),
       do: %Monkey{
         id: id,
         items: items,
         operation: operation,
         condition: condition,
         throw_true: throw_true,
         throw_false: throw_false,
         inspected: 0
       }
end
