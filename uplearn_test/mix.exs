defmodule UplearnTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :uplearn_test,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :hackney]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:floki, "~> 0.31.0"}
    ]
  end
end
