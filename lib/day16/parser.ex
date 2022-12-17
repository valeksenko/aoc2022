defmodule AoC2022.Day16.Parser do
  import NimbleParsec

  valve = ascii_string([?A..?Z], 2)

  valves =
    times(
      valve
      |> ignore(optional(string(", "))),
      min: 1
    )
    |> wrap()

  pipe =
    ignore(string("Valve "))
    |> concat(valve)
    |> ignore(string(" has flow rate="))
    |> concat(integer(min: 1))
    |> ignore(string("; tunnel"))
    |> ignore(optional(string("s")))
    |> ignore(string(" lead"))
    |> ignore(optional(string("s")))
    |> ignore(string(" to valve"))
    |> ignore(optional(string("s")))
    |> ignore(string(" "))
    |> concat(valves)

  # Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  defparsec(:parse, pipe |> eos())

  def pipe_parser(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &to_pipe/2)
    |> IO.inspect
  end

  defp to_pipe({:ok, [valve, rate, valves], "", _, _, _}, pipes), do: Map.put(pipes, valve, {rate, valves})
end
