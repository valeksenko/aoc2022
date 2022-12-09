defmodule AoC2022.Day09.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/9
  """
  alias __MODULE__, as: State

  defstruct [:head, :tail, :visited]

  @left "L"
  @right "R"
  @up "U"
  @down "D"

  @start {0, 0}

  @directions %{
    @left => {-1, 0},
    @right => {1, 0},
    @up => {0, -1},
    @down => {0, 1}
  }

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&to_move/1)
    |> Enum.reduce(
      %State{head: @start, tail: @start, visited: MapSet.new([@start])},
      &move_steps/2
    )
    |> (fn state -> MapSet.size(state.visited) end).()
  end

  defp move_steps({direction, steps}, state) do
    1..steps
    |> Enum.reduce(state, fn _, s -> s |> move_head(direction) |> move_tail() end)
  end

  defp move_head(state, direction),
    do: %{state | head: move(state.head, Map.fetch!(@directions, direction))}

  defp move_tail(state) do
    state.head
    |> next_tail(state.tail)
    |> mark_move(%{state | head: state.head})
  end

  defp next_tail({xh, yh}, {xt, yt}) when abs(xh - xt) <= 1 and abs(yh - yt) <= 1, do: {xt, yt}
  defp next_tail({xh, yh}, {xt, yt}) when xh == xt, do: move({xt, yt}, {0, straight(yh, yt)})
  defp next_tail({xh, yh}, {xt, yt}) when yh == yt, do: move({xt, yt}, {straight(xh, xt), 0})
  defp next_tail({xh, yh}, {xt, yt}), do: move({xt, yt}, {diagonal(xh, xt), diagonal(yh, yt)})

  defp straight(a, b) when abs(a - b) <= 1, do: 0
  defp straight(a, b) when a > b, do: 1
  defp straight(a, b) when a < b, do: -1

  defp diagonal(a, b), do: if(a > b, do: 1, else: -1)

  defp mark_move(tail, state), do: %{state | tail: tail, visited: MapSet.put(state.visited, tail)}

  defp move({x, y}, {xv, yv}), do: {x + xv, y + yv}

  defp to_move(input) do
    input
    |> String.split(" ")
    |> (fn [direction, steps] -> {direction, String.to_integer(steps)} end).()
  end
end
