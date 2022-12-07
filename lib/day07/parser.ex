defmodule AoC2022.Day07.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)

  file =
    integer(min: 1)
    |> ignore(string(" "))
    |> ascii_string([?., ?a..?z], min: 1)
    |> tag(:file)

  dir =
    ignore(string("dir "))
    |> ascii_string([?a..?z], min: 1)
    |> tag(:dir)

  output =
    times(
      choice([
        dir,
        file
      ])
      |> ignore(new_line),
      min: 1
    )
    |> tag(:output)

  ls_command =
    ignore(string("ls"))
    |> tag(:ls_command)

  cd_command =
    ignore(string("cd "))
    |> ascii_string([?., ?/, ?a..?z], min: 1)
    |> tag(:cd_command)

  command =
    ignore(string("$ "))
    |> choice([
      cd_command,
      ls_command
    ])
    |> ignore(new_line)
    |> tag(:command)

  listing =
    repeat(
      choice([
        command,
        output
      ])
    )
    |> ignore(optional(new_line))
    |> eos()

  defparsec(:parse, listing)

  def listing_parser(data) do
    data
    |> parse
    |> to_listing
  end

  defp to_listing({:ok, listing, "", _, _, _}), do: listing
end
