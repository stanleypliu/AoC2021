defmodule DayThreeExercise do
  import Helpers

  def power_consumption(filename) do
    calculate_gamma_rate(filename) * calculate_epsilon_rate(filename)
  end

  def calculate_gamma_rate(filename) do
    mapped_binary_strings = parse_file_into_list_of_chars(filename) |> transpose_strings()

    Enum.reduce(mapped_binary_strings, [], fn current_elem, acc ->
      most_frequent_digit = get_most_frequent_digit(current_elem) |> List.wrap()

      acc ++ most_frequent_digit
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def calculate_epsilon_rate(filename) do
    mapped_binary_strings = parse_file_into_list_of_chars(filename) |> transpose_strings()

    Enum.reduce(mapped_binary_strings, [], fn current_elem, acc ->
      least_frequent_digit = get_least_frequent_digit(current_elem) |> List.wrap()

      acc ++ least_frequent_digit
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def calculate_life_support_rating(filename) do
    calculate_oxygen_generator_rating(filename) * calculate_scrubber_rating(filename)
  end

  def calculate_oxygen_generator_rating(filename) do
    calculate_rating(filename, &most_frequent_digit_via_position/2)
  end

  def calculate_scrubber_rating(filename) do
    calculate_rating(filename, &least_frequent_digit_via_position/2)
  end

  def calculate_rating(filename, search_function) do
    list_of_numbers = parse_file_into_list_of_chars(filename)

    mapped_binary_strings = transpose_strings(list_of_numbers)

    recurse(%{
      list_of_numbers: list_of_numbers,
      mapped_binary_strings: mapped_binary_strings,
      position: 0
    }, search_function)
    |> Map.get(:list_of_numbers)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def recurse(map, transformation) do
    case Enum.count(map.list_of_numbers) do
      1 ->
        map

      _ ->
        list_of_numbers = map.list_of_numbers
        binary_strings = map.mapped_binary_strings
        position = map.position

        digit_for_comparison = transformation.(binary_strings, position)

        updated_list_of_numbers =
          Enum.filter(list_of_numbers, fn current_elem ->
            Enum.at(current_elem, position) == digit_for_comparison
          end)

        updated_position = map.position + 1

        updated_binary_strings = transpose_strings(updated_list_of_numbers)

        recurse(%{
          list_of_numbers: updated_list_of_numbers,
          mapped_binary_strings: updated_binary_strings,
          position: updated_position
        }, transformation)
    end
  end

  def prune_list(list, number) do
    Enum.filter(list, fn x -> x == number end)
  end

  def most_frequent_digit_via_position(list_of_lists, position) do
    get_most_frequent_digit(Enum.at(list_of_lists, position))
    |> elem(0)
  end

  def least_frequent_digit_via_position(list_of_lists, position) do
    get_least_frequent_digit(Enum.at(list_of_lists, position))
    |> elem(0)
  end

  def get_most_frequent_digit(list) do
    frequencies = Enum.frequencies(list)

    if Enum.max(Map.values(frequencies)) == Enum.min(Map.values(frequencies)) do
      {"1", 1}
    else
      Enum.max_by(frequencies, &elem(&1, 1))
    end
  end

  def get_least_frequent_digit(list) do
    frequencies = Enum.frequencies(list)

    if Enum.max(Map.values(frequencies)) == Enum.min(Map.values(frequencies)) do
      {"0", 1}
    else
      Enum.min_by(frequencies, &elem(&1, 1))
    end
  end

  def transpose_strings(list_of_strings) do
    list_of_strings
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def parse_file_into_list_of_chars(filename) do
    read_file(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end
end
