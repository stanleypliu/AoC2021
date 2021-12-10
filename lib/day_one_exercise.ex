defmodule DayOneExercise do
  def read_file(filename) do
    with {:ok, contents} <- File.read(filename) do
      contents
    end
  end

  def parse_file_into_numbers_list(filename) do
    read_file(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def count_increases(filename) do
    list_of_measurements = parse_file_into_numbers_list(filename)

    count_consecutive_increases(list_of_measurements, &Function.identity/1)
  end

  def measurement_window_comparison(filename) do
    list_of_measurements = parse_file_into_numbers_list(filename)

    chunked_list = Enum.chunk_every(list_of_measurements, 3, 1)

    count_consecutive_increases(chunked_list, &Enum.sum/1)
  end

  def count_consecutive_increases(list, transform) do
    map_of_counts = Enum.reduce(list, %{last_elem: nil, count: 0, values: [List.first(list)]}, fn current_elem, acc ->
      new_count = if transform.(current_elem) > transform.(List.last(acc.values)), do: acc.count + 1, else: acc.count
      %{last_elem: current_elem, values: acc.values ++ [current_elem], count: new_count}
    end)

    map_of_counts.count
  end
end
