defmodule AoC2022.Day19.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/19
  """
  @days 24

  @behaviour AoC2022.Day

  @geode 0
  @obsidian 1
  @clay 2
  @ore 3

  @materials [@geode, @obsidian, @clay, @ore]

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&quality_level/1)
    |> Enum.sum()
  end

  defp quality_level({id, blueprint}) do
    id * collect_geodes(blueprint)
  end

  defp collect_geodes(blueprint) do
    {Map.from_keys(@materials, 0), %{@ore => 1}}
    |> Stream.iterate(&daily(&1, blueprint))
    |> Stream.drop(@days)
    |> Enum.take(1)
    |> hd()
    |> IO.inspect(label: "result")
    |> elem(0)
    |> Map.get(@geode)
  end

  defp daily({collected, robots}, blueprint) do
    with {reminder, new_robots} <-
           make_robots({collected, robots}, [@geode, @obsidian, @clay, @ore], blueprint),
         do: {collect_materials(reminder, robots), new_robots}
  end

  defp collect_materials(collected, robots),
    do:
      Enum.reduce(@materials, collected, fn i, c ->
        Map.update!(c, i, &(&1 + Map.get(robots, i, 0)))
      end)

  defp make_robots({collected, robots}, required, blueprint) do
    material = hd(required)

    if enough_for_robot?(required, collected),
      do:
        {collected, robots}
        |> make_robot(material, blueprint[material])
        |> make_robots(material, blueprint)
        |> IO.inspect(label: "#{material} -- #{inspect(collected)}"),
      else: {collected, robots}
  end

  defp enough_for_robot?(required, collected) do
    required
    |> Enum.with_index()
    |> Enum.all?(fn {m, i} -> collected[i] >= m end)
  end

  defp make_robot({collected, robots}, material, required) do
    {
      required
      |> Enum.with_index()
      |> Enum.reduce(collected, fn {m, i}, c -> Map.update!(c, i, &(&1 - m)) end),
      Map.update(robots, material, 1, &(&1 + 1))
    }
  end

  defp parse(input) do
    input
    |> String.split(~r{[^-\d]}, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_blueprint()
  end

  def to_blueprint([id, ore_ore, clay_ore, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian]),
      do: {
        id,
        %{
          @ore => [0, 0, 0, ore_ore],
          @clay => [0, 0, 0, clay_ore],
          @obsidian => [0, 0, obsidian_clay, obsidian_ore],
          @geode => [0, geode_obsidian, 0, geode_ore]
        }
      }
end
