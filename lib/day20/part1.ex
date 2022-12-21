defmodule AoC2022.Day20.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/20
  """
  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> mix()
    |> Enum.map(&elem(&1, 0))
    |> result()
  end

  defp result(decrypted) do
    with ind <- Enum.find_index(decrypted, &(&1 == 0)),
         limit <- length(decrypted) do
      [1_000, 2_000, 3_000]
      |> Enum.map(&Integer.mod(&1 + ind, limit))
      |> Enum.map(&Enum.at(decrypted, &1))
      |> Enum.sum()
    end
  end

  defp mix(encrypted) do
    with limit <- length(encrypted) do
      encrypted
      |> Enum.reduce(encrypted, fn {n, i}, d -> move(i, d, Integer.mod(n, limit - 1)) end)
    end
  end

  defp move(i, decrypted, ind) do
    decrypted
    |> Enum.split_while(&(elem(&1, 1) != i))
    |> insert(ind)
  end

  defp insert({l1, [num | l2]}, ind), do: List.insert_at(l2 ++ l1, ind, num)
end
