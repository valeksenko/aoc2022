defmodule AoC2022.Day19.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/minute/19
  """
  @minutes 24

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
    {
      %{@geode => 0, @obsidian => 0, @clay => 0, @ore => 1},
      Map.from_keys(@materials, 0)
    }
    |> Stream.iterate(&collect_geod(&1, blueprint))
    |> Stream.drop(@minutes)
    |> Enum.take(1)
    |> hd()
    |> IO.inspect(label: "result")
    |> elem(0)
    |> Map.get(@geode)
  end

  defp collect_geod({robots, collected}, blueprint) do
    with {made, leftovers} <- make_robots(@geode, 1, blueprint, robots, collected)
    do
      {
        made,
        collect_materials(leftovers, robots),
      } |> IO.inspect
    end
  end

  defp make_robots(_, 0, _, robots, collected), do: {robots, collected}
  
  # defp make_robots(material, amount, blueprint, robots, collected) do
  #   with possible <- possilbe_makes(blueprint[material], amount, collected)
  #   do
  #     blueprint[material]
  #     |> Enum.reject(&enough_materials?(&1, material, possible, collected))
  #     |> Enum.reduce(
  #       make_robot(blueprint, material, possible, robots, collected),
  #       fn {m, a}, {r, c} -> make_robots(m, a * (amount - possible), blueprint, r, c) end
  #     )
  #   end
  # end

  defp make_robots(material, amount, blueprint, robots, collected) do
    with possible <- possilbe_makes(blueprint[material], amount, collected),
      made <- make_robot(blueprint, material, possible, robots, collected)
    do
      if material == @ore,
        do: made,
        else: Enum.reduce(
          blueprint[material],
          made,
          fn {m, a}, {r, c} -> make_robots(m, a * (amount - possible), blueprint, r, c) end
        )
    end
  end

  defp possilbe_makes(required, amount, collected) do
    required
    |> Enum.map(&max_makes(&1, amount, collected))
    |> Enum.min()
  end

  # defp enough_materials?(_, @ore, _, _), do: true
  # defp enough_materials?(required, _, amount, collected), do: max_makes(required, amount, collected) == required

  defp max_makes({material, amount}, required, collected) do
    collected
    |> Map.get(material, 0)
    |> div(amount)
    |> min(required)
  end

  defp make_robot(blueprint, material, amount, robots, collected) do
    {
      Map.update(robots, material, amount, &(&1 + amount)),
      Enum.reduce(
        blueprint[material],
        collected,
        fn {m, required}, c -> Map.update!(c, m, &(&1 - amount * required)) end
      )
    }
  end

  defp collect_materials(collected, robots),
    do:
      Enum.reduce(
        @materials,
        collected,
        fn m, c ->
          Map.update!(c, m, &(&1 + robots[m]))
        end
      )

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
          @ore => %{@ore => ore_ore},
          @clay => %{@ore => clay_ore},
          @obsidian => %{@clay => obsidian_clay, @ore => obsidian_ore},
          @geode => %{@obsidian => geode_obsidian, @ore => geode_ore}
        }
      }
end
