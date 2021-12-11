defmodule DayThreeExercise do
  import Helpers

  def power_consumption(filename) do
    calculate_gamma_rate(filename) * calculate_epsilon_rate(filename)
  end
  def calculate_gamma_rate(filename) do
    mapped_binary_strings = transpose_strings(filename)

    Enum.reduce(mapped_binary_strings, [], fn current_elem, acc ->
      most_frequent_digit =
        Enum.frequencies(current_elem)
        |> Enum.max_by(&elem(&1, 1))
        |> List.wrap()

      acc ++ most_frequent_digit
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def calculate_epsilon_rate(filename) do
    mapped_binary_strings = transpose_strings(filename)

    Enum.reduce(mapped_binary_strings, [], fn current_elem, acc ->
      least_frequent_digit =
        Enum.frequencies(current_elem)
        |> Enum.min_by(&elem(&1, 1))
        |> List.wrap()

      acc ++ least_frequent_digit
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def transpose_strings(filename) do
    read_file(filename)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
  end
end
