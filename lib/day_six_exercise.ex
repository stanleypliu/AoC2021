defmodule DaySixExercise do
  import Helpers

  def calculate_number_of_fish(filename, days) do
    original_fish =
      read_file(filename)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    fish_reproduction_cycle(
      original_fish,
      days,
      0
    )
    |> Enum.count()
  end

  def fish_reproduction_cycle(total_population, days, counter) do
    cond do
      counter == days ->
        total_population

      counter != days ->
        newly_pregnant_fish =
          Enum.filter(total_population, fn fish ->
            fish == 0
          end)

        immature_fish =
          (total_population -- newly_pregnant_fish)
          |> Enum.map(fn fish ->
            fish - 1
          end)

        fish_and_children =
          case Enum.count(newly_pregnant_fish) do
            0 ->
              []

            _ ->
              for _ <- 1..Enum.count(newly_pregnant_fish), do: [6, 8]
          end

        updated_population = (immature_fish ++ fish_and_children) |> List.flatten()

        fish_reproduction_cycle(updated_population, days, counter + 1)
    end
  end

  # Going with José Valim's solution for part 2 due to its performance
  def faster_solution(filename, days) do
    original_fish =
      read_file(filename)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    frequencies = Enum.frequencies(original_fish)
    amounts = Enum.map(0..8, fn i -> frequencies[i] || 0 end) |> List.to_tuple()

    if days > 1 do
      1..days
      |> Enum.reduce(amounts, fn _, amounts -> recurse(amounts) end)
      |> Tuple.sum()
    end
  end

  def recurse({day0, day1, day2, day3, day4, day5, day6, day7, day8}) do
    {day1, day2, day3, day4, day5, day6, day7 + day0, day8, day0}
  end
end
