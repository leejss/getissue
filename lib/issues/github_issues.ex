defmodule Issues.GithubIssues do
  @user_agent [{"User-Agent", "Elixir goldemshine@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project) |> HTTPoison.get(@user_agent) |> handle_response
  end

  @github_url Application.compile_env(:issues, :github_url)

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  # def handle_response({_, %{status_code: _, body: body}}) do
  #   {:error, body}
  # end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!(%{})
    }
  end

  # def   do
  # end

  def check_for_error(200) do
    :ok
  end

  def check_for_error(_) do
    :error
  end
end
