defmodule AoC2022.Day07.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/7
  """
  import AoC2022.Day07.Parser

  @total_space 70_000_000
  @needed_space 30_000_000

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> listing_parser
    |> Enum.reduce({%{}, []}, &traverse/2)
    |> elem(0)
    |> Map.values()
    |> Enum.sort(:desc)
    |> result
  end

  defp result([used | sizes]) do
    sizes
    |> Enum.reverse()
    |> Enum.find(&(@total_space - used + &1 > @needed_space))
  end

  defp traverse({:command, [cd_command: [dir]]}, {sizes, path}) do
    case dir do
      "/" -> {sizes, ["/"]}
      ".." -> {sizes, tl(path)}
      _ -> {sizes, [dir | path]}
    end
  end

  defp traverse({:command, [ls_command: []]}, {sizes, path}) do
    {sizes, path}
  end

  defp traverse({:output, output}, {sizes, path}) do
    {add_size(output |> Enum.map(&out_size/1) |> Enum.sum(), sizes, path), path}
  end

  defp out_size({:dir, _}), do: 0
  defp out_size({:file, [size, _]}), do: size

  defp add_size(_, sizes, []), do: sizes

  defp add_size(size, sizes, path) do
    add_size(size, Map.update(sizes, path, size, &(&1 + size)), tl(path))
  end
end
