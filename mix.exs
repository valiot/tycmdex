defmodule Tycmdex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tycmdex,
      version: "0.1.0",
      elixir: "~> 1.9",
      name: "Tycmdex",
      description: description(),
      package: package(),
      source_url: "https://github.com/valiot/tycmdex",
      start_permanent: Mix.env() == :prod,
      compilers: [:cmake] ++ Mix.compilers(),
      docs: [extras: ["README.md"], main: "readme"],
      build_embedded: true,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Elixir wrapper for tycmd (tytools), for programming Teensy boards."
  end

  defp package() do
    [
      files: [
        "lib",
        "src/tytools/src/libhs",
        "src/tytools/src/libty",
        "src/tytools/src/tycmd",
        "src/tytools/cmake",
        "src/tytools/tests",
        "CMakeLists.txt",
        "test",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      maintainers: ["valiot"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/valiot/abex"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_cmake, github: "valiot/elixir-cmake"},
      #{:elixir_cmake, "~> 0.1.0"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:jason, "~> 1.1"},
      {:muontrap, "~> 0.5.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
