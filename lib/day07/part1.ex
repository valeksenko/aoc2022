defmodule AoC2022.Day07.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/7
  """
  import AoC2022.Day07.Parser

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> listing_parser
    |> Enum.reduce({%{}, []}, &traverse/2)
    |> elem(0)
    |> Map.values()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
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
