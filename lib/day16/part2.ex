defmodule AoC2022.Day16.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/16#part2
  """
  import AoC2022.Day16.Parser

  @start "AA"
  @time 26

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> pipe_parser()
    |> find_path()
    # |> IO.inspect
    |> List.last()
    |> elem(0)
  end

  defp find_path(pipes) do
    nbs = fn state -> check_valves(state, pipes) |> prune() end

    max = pipes |> Enum.map(fn {_, {rate, _}} -> rate * @time end) |> Enum.sum()
    cost = fn {p1, _, t1, _}, {p2, _, t2, _} -> max - (t2 * p2 - t1 * p1) end
    estimated_cost = fn _, _ -> 1 end

    Astar.astar(
      {nbs, cost, estimated_cost},
      {0, [@start, @start], @time, []},
      fn {_, _, time, _} -> time == 1 end
    )
  end

  defp prune(visits) do
    visits
    |> Enum.reject(fn {pressure, _, time, _} -> pressure == 0 && time < @time - 4 end)
    |> Enum.uniq()

    # |> IO.inspect
  end

  defp check_valves({pressure, valves, time, opened}, pipes) when time < 2,
    do: release_pressure({opened, valves}, opened, pressure, time, pipes)

  defp check_valves({pressure, [valve1, valve2], time, opened}, pipes) do
    check_valve(valve1, opened, pipes, [])
    |> Enum.flat_map(fn {o, v} -> check_valve(valve2, o, pipes, v) end)
    |> Enum.map(&release_pressure(&1, opened, pressure, time, pipes))
  end

  defp check_valve(valve, opened, pipes, valves) do
    [
      {open(valve, pipes[valve], opened) ++ opened, [valve | valves]}
      | move(pipes[valve], opened, valves)
    ]
  end

  defp open(_, {0, _}, _), do: []

  defp open(valve, _, opened) do
    if valve in opened,
      do: [],
      else: [valve]
  end

  defp move({_, next}, opened, valves),
    do: Enum.map(next, &{opened, [&1 | valves]})

  defp release_pressure({to_open, valves}, opened, pressure, time, pipes) do
    {
      Enum.reduce(opened, pressure, fn v, p -> p + elem(pipes[v], 0) end),
      valves,
      time - 1,
      to_open
    }
  end
end
