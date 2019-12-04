# Tycmdex

Elixir wrapper of tycmd (tytools), for programming Teensy boards.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tycmdex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tycmdex, "~> 0.1.0"}
    # the current elixir-cmake hex package (0.1.0) is not compatible.
    {:elixir_cmake, github: "valiot/elixir-cmake", override: true}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tycmdex](https://hexdocs.pm/tycmdex).

