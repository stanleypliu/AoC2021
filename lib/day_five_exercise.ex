defmodule DayFiveExercise do
  import Helpers

  def parse_lines(filename) do
    read_file(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "->", trim: true))
    |> Enum.map(fn coordinates_pair ->
      Enum.map(coordinates_pair, fn coordinates ->
        xy = String.split(coordinates, ",")
        [x, y] = Enum.map(xy, fn coord ->
          String.trim(coord) |> String.to_integer()
        end)

        {x, y}
      end)
    end)
  end

  def find_interpolated_coordinates(filename) do
    vent_lines = parse_lines(filename)

    Enum.map(vent_lines, fn vent_line ->
      [{x1, y1}, {x2, y2}] = vent_line


      cond do
        x1 != x2 && y1 == y2 ->
          if x1 - x2 == 1 || x2 - x1 == 1 do
            vent_line
          else
            vent_line ++ create_new_tuples([x1, x2], y1, :along_x)
          end

        y1 != y2 && x1 == x2 ->
          if y1 - y2 == 1 || y2 - y1 == 1 do
            vent_line
          else
            vent_line ++ create_new_tuples([y1, y2], x1, :along_y)
          end

        x1 != x2 && y1 != y2 ->
          vent_line

        x1 == x2 && y1 == y2 ->
          vent_line
      end

    end)
  end

  def find_intersections(filename) do
    interpolated_lines = find_interpolated_coordinates(filename)
    IO.inspect(interpolated_lines)
    List.flatten(interpolated_lines)
    |> Enum.frequencies()
    |> Enum.filter(fn {_, v} ->
      v >= 2
    end)
    |> Enum.count()
  end

  def create_new_tuples(range, static_coord, dimension) do
    # Sorts from lowest to highest
    sorted_range_tuple = Enum.sort(range)

    [n1, n2] = sorted_range_tuple

    sorted_range = Range.new(n1 + 1, n2 - 1)

    Enum.map(sorted_range, fn n ->
      case dimension do
        :along_x ->
          {n, static_coord}

        :along_y ->
          {static_coord, n}
      end
    end)
  end
end
