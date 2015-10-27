defmodule FaviconTest do
  use ExUnit.Case
  doctest Favicon

  test "fetch a favicon" do
    url = "http://nwt.se"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/static/ico/nwtse-favicon.png"
  end

  test "fetch another favicon" do
    url = "http://compare.se"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/sites/default/files/favicon.png"
  end

  test "fetch yet another favicon" do
    url = "http://www.nordea.se"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/favicon.ico"
  end

  test "fetch favicon from http facebook (redirects to https)" do
    url = "http://www.facebook.com"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/icon.svg"
  end

  test "try fetching favicon from site without favicon" do
    url = "http://lasmastarn.se"
    assert {:error, :favicon_missing} == Favicon.fetch(url)
  end

  test "fetch one without link tag in body" do
    url = "http://hexdocs.pm/ecto/Ecto.html"
    {:ok, result} = Favicon.fetch(url)
    assert result == "http://hexdocs.pm/favicon.ico"
  end
end
