defmodule InOut do
  @doc """
  """

  def get_name do
    "What't your name? " |> IO.gets |> String.trim
  end

  def get_txt do
    path = Path.expand("support/elixir.txt", __DIR__)
    case File.read(path) do
      {:ok, content} -> content
      {:error, reason} -> reason
    end
  end

  def get_choice do
    IO.getn("Do you like elixir? [y|n] ")
  end

  def run do
    name = get_name()
    case String.downcase(get_choice()) do
      "y" ->
        IO.puts "Great! #{name}"
        IO.puts get_txt()
      "n" -> IO.puts "That's a shame, #{name}"
      _ -> IO.puts "You should enter 'y' or 'n'."
    end
  end

end

InOut.run

