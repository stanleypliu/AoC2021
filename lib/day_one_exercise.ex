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

    map_of_counts = Enum.reduce(list_of_measurements, %{last_num: nil, count: 0, values: [List.first(list_of_measurements)]}, fn x, acc ->
      new_count = if x > List.last(acc.values), do: acc.count + 1, else: acc.count
      %{last_num: x, values: acc.values ++ [x], count: new_count}
    end
    )

    map_of_counts.count
  end
end
