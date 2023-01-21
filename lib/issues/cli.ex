defmodule Issues.CLI do
  import Issues.Formatter, only: [print_table_for_columns: 2]
  @default_count 4

  @moduledoc """
    명령줄 파싱
  """

  def main(argv) do
    # parse_argv(argv)
    argv |> parse_argv |> process
  end

  def process(:help) do
    IO.puts("""
      usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_descending_order
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def last(list, count) do
    list |> Enum.take(count) |> Enum.reverse()
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def parse_argv(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end
end
