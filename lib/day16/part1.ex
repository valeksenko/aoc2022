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
    |> pressures()
    |> Enum.map(&elem(&1, 0))
    |> Enum.max()
  end

  defp pressures(pipes) do
    [{0, @start, @time, []}]
    |> Stream.iterate(&visit(pipes, &1))
    |> Stream.drop_while(fn v -> Enum.any?(v, &has_time?/1) end)
    |> Enum.take(1)
    |> hd()
  end

  defp visit(pipes, visits) do
    visits
    |> Enum.flat_map(&check_valve(pipes, &1))
    |> prune()
  end

  defp prune(visits) do
    visits
    |> Enum.reject(fn {pressure, _, time, _} -> pressure == 0 && time < @time - 2 end)
    |> Enum.uniq()
  end

  defp has_time?({_, _, time, _}), do: time > 0

  defp check_valve(pipes, {pressure, valve, time, opened}) do
    pipes[valve]
    |> elem(1)
    |> Enum.flat_map(fn v -> next(v, pipes[v], time - 1, pressure, opened) end)
  end

  defp next(valve, _, time, pressure, opened) when time < 1, do: [{pressure, valve, 0, opened}]
  defp next(valve, {0, _}, time, pressure, opened), do: [{pressure, valve, time, opened}]

  defp next(valve, {rate, _}, time, pressure, opened) do
    if valve in opened,
      do: [{pressure, valve, time, opened}],
      else: [
        {pressure + rate * (time - 1), valve, time - 1, [valve | opened]},
        {pressure, valve, time, opened}
      ]
  end
end
