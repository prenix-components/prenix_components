defmodule PrenixComponents.MixProject do
  use Mix.Project

  def project do
    [
      app: :prenix_components,
      version: "0.1.8",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:phoenix_live_view, "~> 0.20.1"},
      {:gettext, "~> 0.20"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description() do
    """
    Prebuilt UI components for Phoenix inspired by NextUI.
    """
  end

  defp package do
    [
      maintainers: ["Sean Yeoh"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/prenix-components/prenix_components"},
      files: ~w(assets config lib vendors LICENSE.md mix.exs README.md)
    ]
  end
end
