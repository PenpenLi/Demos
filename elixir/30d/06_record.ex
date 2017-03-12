ExUnit.start

defmodule User do
  defstruct email: nil, password: nil
end

defimpl String.Chars, for: User do
  def to_string(%User{email: email}) do
    email
  end
end

defmodule RecordTest do
  use ExUnit.Case

  def sample do
    %User{email: "lxb@xl.net", password: "123456"}
  end

  test "defstruct" do
    assert sample = %{__struct__: User, email: "lxb@xl.net", password: "123456"}
  end

  test "property" do
    assert sample.email == "lxb@xl.net"
  end

  test "update" do
    u = sample
    u2 = %User{u|email: "xb@xl.net"}
    assert u2 == %User{email: "xb@xl.net", password: "123456"}
  end

  test "protocol" do
    assert to_string(sample) == "lxb@xl.net"
  end

end

