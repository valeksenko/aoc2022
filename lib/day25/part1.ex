defmodule AoC2022.Day25.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2022/day/25
  """

  @base 5

  @decoder %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "-" => -1,
    "=" => -2
  }

  @encoder %{
    0 => {"0", 0},
    1 => {"1", 0},
    2 => {"2", 0},
    3 => {"=", 1},
    4 => {"-", 1},
    5 => {"0", 1}
  }

  @behaviour AoC2022.Day

  @impl AoC2022.Day
  def run(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&decode/1)
    |> Enum.sum()
    |> encode()
  end

  defp decode(encoded) do
    encoded
    |> Enum.map(fn {v, i} -> @base ** i * @decoder[v] end)
    |> Enum.sum()
  end

  defp encode(num) do
    num
    |> Integer.digits(5)
    |> Enum.reverse()
    |> Enum.reduce({"", 0}, &encode_digit/2)
    |> (fn {e, c} -> if c == 0, do: e, else: @encoder[1] <> e end).()
  end

  defp encode_digit(digit, {encoded, carry}) do
    with {e, c} <- @encoder[digit + carry] do
      {
        e <> encoded,
        c
      }
    end
  end

  defp parse(data) do
    data
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
  end
end
