defmodule AoC2022.Day05.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/5
  """
  import AoC2022.Day05.Parser

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    {stacks, procedure} = instructions_parser(data)

    procedure
    |> Enum.reduce(stacks, &exec/2)
    |> Enum.map(&hd/1)
    |> Enum.join()
  end

  defp exec({amount, from, to}, stacks) do
    1..amount
    |> Enum.reduce(stacks, fn _, s -> move(s, from - 1, to - 1) end)
  end

  defp move(stacks, from, to) do
    {[stack | reminder], stacks} = List.pop_at(stacks, from)

    stacks
    |> List.insert_at(from, reminder)
    |> List.update_at(to, fn r -> [stack | r] end)
  end
end
