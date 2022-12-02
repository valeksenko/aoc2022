defmodule AoC2022.Day02.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/2#part2
  """
  @behaviour AoC2022.Day

  @guide %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :loose,
    "Y" => :draw,
    "Z" => :win
  }

  @score %{
    :rock => 1,
    :paper => 2,
    :scissors => 3,
    :loose => 0,
    :draw => 3,
    :win => 6
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

  defp play([player1, result]) do
    @score[result] + @score[shape(player1, result)]
  end

  defp shape(:rock, :loose), do: :scissors
  defp shape(:scissors, :loose), do: :paper
  defp shape(:paper, :loose), do: :rock

  defp shape(:scissors, :win), do: :rock
  defp shape(:paper, :win), do: :scissors
  defp shape(:rock, :win), do: :paper

  defp shape(player1, :draw), do: player1
end
