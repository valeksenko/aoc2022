defmodule AoC2022.Day22.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)

  path =
    times(
      choice([
        ascii_string([?R, ?L], 1),
        integer(min: 1)
      ])
      |> ignore(optional(new_line)),
      min: 1
    )
    |> tag(:path)

  board =
    times(
      times(
        ascii_string([?\s, ?., ?#], 1),
        min: 1
      )
      |> ignore(new_line)
      |> wrap(),
      min: 1
    )
    |> tag(:board)

  defparsec(:parse, board |> ignore(new_line) |> concat(path) |> eos())

  def instructions_parser(data) do
    data
    |> parse
    |> to_instructions
  end

  defp to_instructions({:ok, [board: board, path: path], "", _, _, _}),
    do: {to_map(board), path}

  defp to_map(board) do
    board
    |> Enum.with_index(1)
    |> Enum.reduce(Map.new(), &add_row/2)
  end

  defp add_row({row, y}, map) do
    row
    |> Enum.with_index(1)
    |> Enum.reduce(map, fn {v, x}, m -> if v == " ", do: m, else: Map.put(m, {x, y}, v) end)
  end
end
