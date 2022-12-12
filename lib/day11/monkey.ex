defmodule AoC2022.Day11.Monkey do
  @enforce_keys [:id, :items, :operation, :condition, :throw_true, :throw_false, :inspected]
  defstruct @enforce_keys
end
