defmodule Fib do
  @moduledoc"""

  """

  @seed [0, 1]

  def fib(n) when n < 2 do
    Enum.take @seed, n
  end
  def fib(n) when n >= 2 do
    fib(@seed, n-2)
  end

  def fib(acc, 0), do: acc
  def fib(acc, n) do
    fib(acc ++ [Enum.at(acc, -2) + Enum.at(acc, -1)], n-1)
  end
end

defmodule Fib2 do
  @seed [1, 0]

  def fib2(n) when n < 2 do
    @seed |> Enum.reverse |> Enum.take(n)
  end
  def fib2(n) when n >=2 do
    fib2(@seed, n-2)
  end

  def fib2(acc, 0), do: Enum.reverse(acc)
  def fib2([first, second|_] = lst, n) do
    fib2([first+second|lst], n-1)
  end
end

ExUnit.start

defmodule FibTest do
  use ExUnit.Case

  import Fib
  import Fib2

  test "fib" do
    assert fib(0) == []
    assert fib(1) == [0]
    assert fib(2) == [0, 1]
    assert fib(10) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
  end

  test "fib2" do
    assert fib2(0) == []
    assert fib2(1) == [0]
    assert fib2(2) == [0, 1]
    assert fib2(10) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
  end

  test "benchmark" do
    {ms, _} = :timer.tc fn -> fib(1000) end
    IO.puts "fib() took #{ms} ms"
    {ms, _} = :timer.tc fn -> fib2(1000) end
    IO.puts "fib2() took #{ms} ms"
  end

  test "" do
    IO.inspect fib(10), label: "fib(10)="
    IO.puts "fib2(10)=#{inspect fib2(10)}"
  end
end

