ExUnit.start

defmodule Test do
  use ExUnit.Case

  test 'sample test' do
    assert 1+1 == 2
  end

  test "refute is opposite of assert" do
    refute 1+1 == 3
  end

  test :assert_raise do
    assert_raise ArithmeticError, fn ->
      1+"x"
    end
  end

  test "assert_in_delta asserts that val1 and val2 differ by less than delta." do
    assert_in_delta 1, 5, 6
  end

end

