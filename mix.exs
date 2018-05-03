defmodule Mix.Tasks.Compile.Salsa20 do
  def run(_) do
    if match? {:win32, _}, :os.type do
      {result, _error_code} = System.cmd("nmake", ["/F", "Makefile.win", "priv\\salsa20_nif.dll"], stderr_to_stdout: true)
      IO.binwrite result
    else
      {result, _error_code} = System.cmd("make", ["priv/salsa20_nif.so"], stderr_to_stdout: true)
      IO.binwrite result
    end
    :ok
  end
end

defmodule Salsa20.MixProject do
  use Mix.Project

  def project do
    [
      app: :salsa20,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      compilers: [:salsa20, :elixir, :app],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
