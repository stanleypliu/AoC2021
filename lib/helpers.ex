defmodule Helpers do
  def read_file(filename) do
    with {:ok, contents} <- File.read(filename) do
      contents
    end
  end
end
