defmodule AoC2022.Day02.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/2
  """
  @behaviour AoC2022.Day

  @guide %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }

  @score %{
    :rock => 1,
    :paper => 2,
    :scissors => 3
  }

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&play/1)
    |> Enum.sum
  end

  defp parse(input) do
    input
    |> String.split
    |> Enum.map(fn v -> @guide[v] end)
  end

  defp play([player1, player2]) do
    @score[player2] + winner(player1, player2)
  end

  defp winner(:rock, :scissors), do: 0
  defp winner(:scissors, :paper), do: 0
  defp winner(:paper, :rock), do: 0

  defp winner(:scissors, :rock), do: 6
  defp winner(:paper, :scissors), do: 6
  defp winner(:rock, :paper), do: 6

  defp winner(_, _), do: 3
end
