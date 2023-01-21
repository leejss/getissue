defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_argv: 1, sort_into_descending_order: 1]

  test "-h나 --help가 옵션으로 파싱되면 :help가 반환된다." do
    assert parse_argv(["-h", "anything"]) == :help
    assert parse_argv(["--help", "anything"]) == :help
  end

  test "값을 3개 전달하면 값 3개가 반환된다" do
    assert parse_argv(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "값을 2개 전달하면 개수에 기본값을 사용한다" do
    assert parse_argv(["user", "project"]) == {"user", "project", 4}
  end

  test "내림차순 정렬 수행" do
    result = sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values do
      %{"created_at" => value, "other" => "xxx"}
    end
  end

  # test "greets the world" do
  #   assert Issues.hello() == :world
  # end
end
