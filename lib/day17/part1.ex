defmodule AoC2022.Day17.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/17
  """
  @total 2022
  @width 0..6
  @gap 3
  @shapes [
    {1, [{0, 0}, {1, 0}, {2, 0}, {3, 0}]},
    {3, [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]},
    {3, [{2, 2}, {2, 1}, {0, 0}, {1, 0}, {2, 0}]},
    {4, [{0, 0}, {0, 1}, {0, 2}, {0, 3}]},
    {2, [{0, 0}, {1, 0}, {0, 1}, {1, 1}]}
  ]
  @wall "="
  @rock "#"
  @direction %{
    ">" => 1,
    "<" => -1
  }

  @behaviour AoC2022.Day

  @impl AoC2022.Day

  def run(data) do
    data
    |> hd()
    |> String.graphemes()
    |> drop_rocks(Map.from_keys(for(x <- @width, do: {x, 0}), @wall))
    |> elem(0)
    |> max_y()
  end

  defp drop_rocks(jets, cave) do
    jets
    |> Stream.cycle()
    |> Enum.reduce_while(next_rock(cave, [], 0), &step/2)
  end

  defp step(_, {cave, rock, @total, top}), do: {:halt, {cave, rock, @total, top}}

  defp step(jet, {cave, rock, amount, top}) do
    # inspect_cave(cave, rock, top)
    case rock |> shift(cave, @direction[jet]) |> down(cave) do
      {:stayed, next} -> {:cont, next_rock(cave, next, amount + 1)}
      {:dropped, next} -> {:cont, {cave, next, amount, top - 1}}
    end
  end

  defp next_rock(cave, rock, amount) do
    with {height, next} <- Enum.at(@shapes, Integer.mod(amount, length(@shapes))),
         map <- Map.merge(cave, Map.from_keys(rock, @rock)),
         top <- max_y(map) + 1 do
      {
        map,
        Enum.map(next, fn {x, y} -> {x + 2, y + top + @gap} end),
        amount,
        top + @gap + height
      }
    end
  end

  defp down(rock, cave) do
    with dropped <- Enum.map(rock, fn {x, y} -> {x, y - 1} end) do
      if taken?(dropped, cave), do: {:stayed, rock}, else: {:dropped, dropped}
    end
  end

  defp shift(rock, cave, amount) do
    with shifted <- Enum.map(rock, fn {x, y} -> {x + amount, y} end) do
      if !taken?(shifted, cave) && Enum.all?(shifted, fn {x, _} -> x in @width end),
        do: shifted,
        else: rock
    end
  end

  defp taken?(rock, cave), do: Enum.any?(rock, fn pos -> Map.has_key?(cave, pos) end)

  defp max_y(cave), do: cave |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

  # defp inspect_cave(cave, rock, top) do
  #   with map <- Map.merge(cave, Map.from_keys(rock, @rock))
  #   do
  #     for y <- top..0 do
  #       for x <- @width do
  #         IO.binwrite(Map.get(map, {x, y}, " "))
  #       end
  #       IO.binwrite("\n")
  #     end
  #   end

  #   IO.binwrite("\n\n")
  # end
end
