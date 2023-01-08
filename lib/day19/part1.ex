defmodule AoC2022.Day19.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/minute/19
  """
  @minutes 10

  @behaviour AoC2022.Day

  @geode 77
  @obsidian 33
  @clay 11
  @ore 1

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
    Astar.astar(
      {
        fn s -> makes(s, blueprint) end,
        fn s, _ -> @minutes * @minutes - geodes(s) end,
        fn {t, r, c}, _ ->
          @minutes * @minutes - t * (score(r, 0) + score(c, 2))
        end
        # fn {t1, r1, c1}, {t2, r2, c2} ->
        #   (@minutes * @minutes) - ((score(r2, 0) + score(c2, 2)) - (score(r1, 0) + score(c1, 2)))
        # end,
        # fn s, _ -> (@minutes * @minutes) - geodes(s) end
        # fn _, _ -> 1 end
      },
      {
        @minutes,
        %{Map.from_keys(@materials, 0) | @ore => 1},
        Map.from_keys(@materials, 0)
      },
      fn {time, _, _} -> time == 0 end
    )
  end

  defp score(map, adjuster) do
    adjuster +
      (map
       |> Enum.map(&Tuple.product/1)
       |> Enum.sum())
  end

  defp makes({time, robots, collected}, blueprint) do
    make_robots([{robots, collected}], @geode, blueprint)
    |> prune(time)
    |> Enum.map(fn {made, leftovers} -> {time - 1, made, collect_materials(leftovers, robots)} end)

    # |> (fn x -> IO.inspect(length(x), label: "makes #{time}"); x end).()
  end

  defp prune(states, time) do
    states
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn {r, c} -> {geodes({time, r, c}), {r, c}} end)
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> take_max()
    |> Enum.map(&elem(&1, 1))
  end

  defp take_max([]), do: []
  defp take_max([{g, s} | t]), do: [{g, s} | Enum.take_while(t, fn {g1, _} -> g1 == g end)]

  defp geodes({time, robots, collected}) do
    collected[@geode] * 3 * time + robots[@geode] * time
  end

  defp make_robots([latest | _] = made, material, blueprint) do
    # TODO: handle recursive robots
    with batch <- make_robot(material, blueprint, latest),
         fresh <- Enum.reject(batch, &(&1 == latest)) do
      if Enum.empty?(fresh),
        # do: (IO.inspect(latest, label: "same"); made),
        do: made,
        # else: (IO.inspect(fresh, label: "new: #{inspect latest}"); Enum.map(fresh, &make_robots([&1 | made], blueprint, cache)))
        else: Enum.map(fresh, &make_robots([&1 | made], blueprint))
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
