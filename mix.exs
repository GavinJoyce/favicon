defmodule Favicon.Mixfile do
  use Mix.Project

  def project do
    [app: :favicon,
     version: "0.0.6",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 1.6"},
     {:floki, "~> 0.23"}]
  end

  defp description do
   """
   A library that fetches the favicon url for a specified url
   """
 end

 defp package do
   [
    files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
    maintainers: ["Richard Nyström"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/ricn/favicon"}]
 end
end
