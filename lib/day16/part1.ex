defmodule AoC2022.Day16.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/16
  """
  import AoC2022.Day16.Parser

  @start "AA"
  @time 30

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> pipe_parser()
    |> find_path()
    |> List.last()
    |> elem(0)
  end

  defp find_path(pipes) do
    nbs = fn state -> check_valve(state, pipes) end

    max = pipes |> Enum.map(fn {_, {rate, _}} -> rate * @time end) |> Enum.sum()
    cost = fn {p1, _, t1, _}, {p2, _, t2, _} -> max - (t2 * p2 - t1 * p1) end
    estimated_cost = fn _, _ -> 1 end

    Astar.astar(
      {nbs, cost, estimated_cost},
      {0, @start, @time, []},
      fn {_, _, time, _} -> time == 1 end
    )
  end

  defp check_valve({pressure, valve, time, opened}, pipes) do
    pipes[valve]
    |> elem(1)
    |> Enum.flat_map(fn v -> next(v, pipes[v], time, pressure, opened, pipes) end)
  end

  defp next(valve, _, time, pressure, opened, pipes) when time < 2,
    do: [release_pressure({pressure, valve, time, opened}, pipes)]

  defp next(valve, {0, _}, time, pressure, opened, pipes),
    do: [release_pressure({pressure, valve, time, opened}, pipes)]

  defp next(valve, _, time, pressure, opened, pipes) do
    if valve in opened,
      do: [release_pressure({pressure, valve, time, opened}, pipes)],
      else: [
        release_pressure({pressure, valve, time, opened}, pipes),
        release_pressure({pressure, valve, time, opened}, pipes)
        |> (fn {p, _, t, o} -> release_pressure({p, valve, t, [valve | o]}, pipes) end).()
      ]
  end

  defp release_pressure({pressure, valve, time, opened}, pipes) do
    {
      Enum.reduce(opened, pressure, fn v, p -> p + elem(pipes[v], 0) end),
      valve,
      time - 1,
      opened
    }
  end
end
