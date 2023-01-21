defmodule FormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Issues.Formatter, as: F

  def split_with_three_columns do
    F.split_into_columns()
  end

  test "컬럼을 나눈다" do
    columns = split_with_three_columns()
    assert length(columns) == length()
    assert List.first(columns) == []
    assert List.last(columns) == []
  end

  test "컬럼의 너비" do
  end

  test "문자열이 올바른 형식으로 반환된다." do
  end

  test "결과가 올바르게 출력된다." do
  end
end
