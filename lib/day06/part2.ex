defmodule AoC2022.Day06.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/6#part2
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> hd()
    |> String.graphemes()
    |> Enum.reduce_while([], &header/2)
    |> length()
  end

  defp header(char, collected),
    do:
      if(marker(char, collected) == 14,
        do: {:halt, [char | collected]},
        else: {:cont, [char | collected]}
      )

  defp marker(char, collected) do
    [char | Enum.take(collected, 13)]
    |> Enum.uniq()
    |> length()
  end
end
