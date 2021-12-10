defmodule DayTwoExercise do
  import Helpers

  def get_product_of_position_and_depth(filename) do
    read_file(filename)
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{horizontal_position: 0, depth: 0}, fn x, acc ->
      [direction, distance] = String.split(x, " ")

      case {direction, distance} do
        {"forward", distance} ->
          %{
            horizontal_position: acc.horizontal_position + String.to_integer(distance),
            depth: acc.depth
          }

        {"down", distance} ->
          %{
            horizontal_position: acc.horizontal_position,
            depth: acc.depth + String.to_integer(distance)
          }

        {"up", distance} ->
          %{
            horizontal_position: acc.horizontal_position,
            depth: acc.depth - String.to_integer(distance)
          }
      end
    end)
    |> Map.values()
    |> Enum.product()
  end

  def get_correct_product(filename) do
    read_file(filename)
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{horizontal_position: 0, depth: 0, aim: 0}, fn x, acc ->
      [direction, distance] = String.split(x, " ")

      case {direction, distance} do
        {"forward", distance} ->
          %{
            horizontal_position: acc.horizontal_position + String.to_integer(distance),
            depth: acc.depth + (acc.aim * String.to_integer(distance)),
            aim: acc.aim
          }

        {"down", distance} ->
          %{
            horizontal_position: acc.horizontal_position,
            depth: acc.depth,
            aim: acc.aim + String.to_integer(distance)
          }

        {"up", distance} ->
          %{
            horizontal_position: acc.horizontal_position,
            depth: acc.depth,
            aim: acc.aim - String.to_integer(distance)
          }
      end
    end)
    |> (&(&1.horizontal_position * &1.depth)/1).()
  end
end
