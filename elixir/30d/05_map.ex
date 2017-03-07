ExUnit.start

defmodule MapTest do
  use ExUnit.Case

  def sample do
    %{a: 1, b: "2", c: '3'}
  end

  test "Map.get" do
    assert 1 == Map.get sample(), :a
    assert "2" == Map.get sample(), :b
    assert '3' == Map.get sample(), :c
  end

  test "[]" do
    assert sample()[:a] == 1
    assert sample()[:no] == nil
  end

  test "." do
    assert sample().c == '3'
    assert_raise KeyError, fn -> sample().no end
  end

  test "Map.fetch" do
    {:ok, val} = Map.fetch sample(), :c
    assert val == '3'
    :error = Map.fetch sample(), :no
  end

  test "Map.put" do
    assert %{a: 1, b: 2, c: '3'} == Map.put sample(), :b, 2
    assert %{a: 1, b: "2", c: '3', d: "4"} == Map.put sample(), :d, "4"
  end

  test "update" do
    assert %{a: 1, b: 2, c: 3} == %{sample() | c: 3, b: 2}
    assert_raise KeyError, fn -> %{sample() | no: 3} end
  end

end
