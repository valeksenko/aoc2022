defmodule AoC2022.Day05.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/5#part2
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
    {from_stacks, stacks} = List.pop_at(stacks, from - 1)
    {move_stacks, keep_stacks} = Enum.split(from_stacks, amount)

    stacks
    |> List.insert_at(from - 1, keep_stacks)
    |> List.update_at(to - 1, fn s -> move_stacks ++ s end)
  end
end
