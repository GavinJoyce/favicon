# Favicon

A library that fetches the favicon url for a specified url

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add favicon to your list of dependencies in `mix.exs`:

        def deps do
          [{:favicon, "~> 0.0.4"}]
        end

  2. Ensure favicon is started before your application:

        def application do
          [applications: [:favicon]]
        end
