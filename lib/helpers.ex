defmodule Helpers do
  def read_file(filename) do
    with {:ok, contents} <- File.read(filename) do
      contents
    end
  end

  def transpose_strings(list_of_strings) do
    list_of_strings
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def stream_and_trim_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
  end
end
