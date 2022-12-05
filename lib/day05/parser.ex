defmodule AoC2022.Day05.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)

  procedure =
    repeat(
      ignore(string("move "))
      |> integer(min: 1)
      |> ignore(string(" from "))
      |> integer(min: 1)
      |> ignore(string(" to "))
      |> integer(min: 1)
      |> ignore(optional(new_line))
      |> reduce({List, :to_tuple, []})
    )
    |> tag(:procedure)

  crate =
    ignore(string("["))
    |> ascii_string([?A..?Z], 1)
    |> ignore(string("]"))
    |> tag(:crate)

  empty =
    ignore(string("   "))
    |> tag(:empty)

  levels =
    repeat(
      repeat(
        choice([
          crate,
          empty
        ])
        |> ignore(optional(string(" ")))
      )
      |> ignore(new_line)
      |> tag(:level)
    )
    |> ignore(ascii_string([?\s, ?1..?9], min: 2))
    |> ignore(new_line)
    |> tag(:levels)

  defparsec(:parse, levels |> ignore(new_line) |> concat(procedure) |> eos())

  def instructions_parser(data) do
    data
    |> parse
    |> to_instructions
  end

  defp to_instructions({:ok, [levels: levels, procedure: procedure], "", _, _, _}),
    do: {levels |> to_stacks, procedure}

  defp to_stacks(levels) do
    levels
    |> Keyword.values()
    |> Enum.map(&Keyword.values/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&List.flatten/1)
  end
end
