defmodule DayFourExercise do
  import Helpers

  def draw_numbers(filename) do
    stream_and_trim_file(filename)
    |> Enum.at(0)
    |> String.split(",")
  end

  def create_board_rows(filename) do
    stream_and_trim_file(filename)
    |> Stream.filter(fn
      x -> !String.contains?(x, ",") && String.length(x) != 0
    end)
    |> Enum.chunk_every(5)
    |> Enum.map(fn board ->
      Enum.map(board, fn board_row ->
        String.split(board_row, " ") |> Enum.filter(fn elem -> elem != "" end)
      end)
    end)
  end

  # Create a map of all numbers in a board to represent that board, with a key corresponding to each number and the initial value being a tuple consisting of its 'coordinate' and false.
  # When a number is drawn and it matches a key, set the second element of the tuple value of that key to true.
  def create_bingo_boards(filename) do
    boards = create_board_rows(filename)

    Enum.map(boards, fn board ->
      Enum.with_index(board, fn board_row, index ->
        row_number = index

        Enum.reduce(Enum.with_index(board_row), %{}, fn digit_with_index, acc ->
          {digit, column_number} = digit_with_index
          coordinates = {row_number, column_number}
          Map.put(acc, coordinates, {digit, false})
        end)
      end)
    end)
    |> Enum.map(&Enum.reduce(&1, %{}, fn mapped_row, acc -> Map.merge(acc, mapped_row) end))
  end

  # Once four in a row/column has been achieved, check the 'rows' and 'columns' of the map to see if a whole row or column will be marked when the next number is drawn.
  # If that happens, stop iterating/drawing numbers.
  # If this is not possible, check every time after a number is marked successfully.
  def calculate_final_score(filename) do
    bingo_boards = create_bingo_boards(filename)
    draw = draw_numbers(filename)

    result = mark_boards(draw, 0, bingo_boards)

    sum_of_all_unmarked_numbers =
      Enum.filter(result.winning_board, fn {_, value} ->
        {_, marked} = value
        marked == false
      end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    sum_of_all_unmarked_numbers * String.to_integer(result.winning_number)
  end

  def mark_boards(draw, index, bingo_boards) do
    cond do
      check_boards_for_win(bingo_boards) != nil ->
        %{
          winning_board: check_boards_for_win(bingo_boards),
          winning_number: Enum.at(draw, index - 1)
        }

      check_boards_for_win(bingo_boards) == nil ->
        drawn_number = Enum.at(draw, index)

        marked_boards =
          Enum.reduce(bingo_boards, [], fn bingo_board, acc ->
            bingo_board_values = Map.to_list(bingo_board)

            found_value =
              Enum.find(bingo_board_values, nil, fn val ->
                {_, {number, _}} = val
                number == drawn_number
              end)

            if found_value do
              {coordinates, {_, _}} = found_value

              updated_board =
                Map.update!(bingo_board, coordinates, fn existing_value ->
                  {number, _} = existing_value
                  {number, true}
                end)

              acc ++ List.wrap(updated_board)
            else
              acc ++ List.wrap(bingo_board)
            end
          end)

        mark_boards(draw, index + 1, marked_boards)
    end
  end

  def check_boards_for_win(boards) do
    Enum.find(boards, fn board ->
      check_updated_board_for_win(board) == true
    end)
  end

  def check_updated_board_for_win(board) do
    board
    |> Enum.chunk_by(fn {key, _} ->
      {row_number, _} = key
      row_number
    end)
    |> Enum.any?(fn row ->
      Enum.all?(row, fn {_, {_, value}} ->
        value == true
      end)
    end) ||
      board
      |> Enum.sort_by(fn {{_, column_number}, _} -> column_number end)
      |> Enum.chunk_by(fn {key, _} ->
        {_, col_number} = key
        col_number
      end)
      |> Enum.any?(fn column ->
        Enum.all?(column, fn {_, {_, value}} ->
          value == true
        end)
      end)
  end
end
