defmodule DayTwoExercise do
  import Helpers

  def calculate_position_and_depth(filename) do
    read_file(filename)
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{horizontal_position: 0, depth: 0}, fn x, acc ->
          [direction, distance] = String.split(x, " ")

          case {direction, distance} do
            {"forward", distance} ->
              %{horizontal_position: acc.horizontal_position + String.to_integer(distance), depth: acc.depth}
            {"down", distance} ->
              %{horizontal_position: acc.horizontal_position, depth: acc.depth + String.to_integer(distance)}
            {"up", distance} ->
              %{horizontal_position: acc.horizontal_position, depth: acc.depth - String.to_integer(distance)}
          end
       end)
    |> Map.values()
    |> Enum.product()
  end
end
