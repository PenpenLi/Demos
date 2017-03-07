ExUnit.start

defmodule ListTest do
  use ExUnit.Case

  def sample do
    ["a", 1, "b", 2]
  end

  test "sigil" do
    assert ["a", "1", "b", "2"] == ~w(a 1 b 2)
  end

  test "head" do
    [head|_] = sample()
    assert head == "a"
  end

  test "tail" do
    [_|tail] = sample()
    assert [1, "b", 2] == tail
  end

  test "last" do
    assert List.last(sample()) == 2
  end

  test "delete" do
    assert ["a", "b", 2] == List.delete(sample(), 1)
  end

  test "Enum.reduce" do
    list = [1, 2, 3, 4]
    sum = Enum.reduce list, 0, &(&1 + &2)
    assert sum == 10
  end

  test "Enum.each" do
    list = [1, 2, 3, 4]
    Enum.each(list, fn(x) -> IO.puts x*2 end)
  end

  test "Enum.filter" do
    list = [1, 2, 3, 4]
    assert [2, 4] = Enum.filter list, &(rem(&1, 2) == 0)
  end

  test "Enum.filter_map" do
    list = [1, 2, 3, 4]
    assert [4, 8] = Enum.filter_map list, &(rem(&1, 2) == 0), &(&1 * 2)
  end

  test "Enum.map" do
    list = [1, 2, 3, 4]
    assert [2, 4, 6, 8] = Enum.map list, &(&1 * 2)
  end

  test "Enum.sort" do
    list = [1, 2, 3, 4]
    assert [4, 3, 2, 1] == Enum.sort list, &(&1 >= &2)
  end

end

