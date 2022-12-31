defmodule AoC2022.Day19.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/minute/19
  """
  @minutes 24

  @behaviour AoC2022.Day

  @geode 1
  @obsidian 7
  @clay 19
  @ore 31

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
    lowest_score(blueprint)
    |> IO.inspect(label: "result")
    |> List.last()
    |> elem(1)
    |> Map.get(@geode)
  end

  defp lowest_score(blueprint) do
    with cache <- :ets.new(:cache, [:set, :protected])
    do
      Astar.astar(
        {
          fn s -> makes(s, blueprint, cache) end,
          fn {_, r1, c1}, {_, r2, c2} -> 100 + (score(r2, 2) + score(c2, 0)) - (score(r1, 2) + score(c1, 0)) end,
          #fn {_, r1, c1}, {_, r2, c2} -> ((score(r2, 2) + score(c2, 0)) - (score(r1, 2) + score(c1, 0))) |> IO.inspect(label: "#{inspect r2[@clay]}:#{inspect r2[@ore]} #{inspect c2[@clay]}:#{inspect c2[@ore]}") end,
          fn _, _ -> 1 end
        },
        {
          @minutes,
          %{Map.from_keys(@materials, 0) | @ore => 1},
          Map.from_keys(@materials, 0),
        },
        fn {time, _, _} -> time == 0 end
      )
    end
  end

  defp score(map, adjuster) do
    adjuster + (
      map
      |> Enum.map(&Tuple.product/1)
      |> Enum.sum()
    )
  end

  defp makes({time, robots, collected}, blueprint, cache) do
    make_robots([{robots, collected}], blueprint, cache)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn {made, leftovers} -> {time - 1, made, collect_materials(leftovers, robots)} end)
    #|> (fn x -> IO.inspect(length(x), label: "makes #{time}"); x end).()
  end

  defp make_robots([latest | _] = made, blueprint, cache) do
    case :ets.lookup(cache, latest) do
      [] -> tap(
        do_make_robots(made, blueprint, cache),
        fn m -> :ets.insert(cache, {latest, m}) end
      )
      #[{_, cached}] -> IO.puts("cached #{inspect elem(latest, 0)[@clay]}:#{inspect elem(latest, 0)[@ore]} #{inspect elem(latest, 1)[@clay]}:#{inspect elem(latest, 1)[@ore]}"); cached
      [{_, cached}] -> cached
    end
  end

  defp do_make_robots([latest | _] = made, blueprint, cache) do
    with batch <- Enum.map(@materials, &make_robot(&1, blueprint, latest)),
         fresh <- Enum.reject(batch, &(&1 == latest))
    do
      if Enum.empty?(fresh),
        #do: (IO.inspect(latest, label: "same"); made),
        do: made,
        #else: (IO.inspect(fresh, label: "new: #{inspect latest}"); Enum.map(fresh, &make_robots([&1 | made], blueprint, cache)))
        else: Enum.map(fresh, &make_robots([&1 | made], blueprint, cache))
    end
  end

  defp enough_materials?(required, collected) do
    required
    |> Enum.all?(fn {m, a} -> Map.get(collected, m, 0) >= a end)
  end

  defp make_robot(material, blueprint, {robots, collected}) do
    if enough_materials?(blueprint[material], collected),
      do: {
          Map.update!(robots, material, &(&1 + 1)),
          Enum.reduce(
            blueprint[material],
            collected,
            fn {m, a}, c -> Map.update!(c, m, &(&1 - a)) end
          )
        },
      else: {robots, collected}
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
