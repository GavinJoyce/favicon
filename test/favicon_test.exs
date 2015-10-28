defmodule FaviconTest do
  use ExUnit.Case, async: true
  doctest Favicon

  test "fetch google favicon" do
    url = "http://www.google.com"
    {:ok, result} = Favicon.fetch(url)
    assert result == "http://www.google.com/images/branding/product/ico/googleg_lodp.ico"
  end

  test "fetch favicon from facebook.com (redirects http to https)" do
    url = "http://www.facebook.com"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/icon.svg"
  end

  test "fetch one with missing link tag" do
    url = "http://hexdocs.pm/ecto/Ecto.html"
    {:ok, result} = Favicon.fetch(url)
    assert result == "http://hexdocs.pm/favicon.ico"
  end

  test "fetch url with absolute favicon url in link tag" do
    url = "https://github.com"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://github.com/fluidicon.png"
  end

  test "fetch from an url with favicon on another domain" do
    url = "http://www.phoenixframework.org/"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://www.filepicker.io/api/file/PQcrhfwISl6TGbtmLCc7"
  end

  test "try fetch with non existent domain" do
    url = "http://thisurldoesnotexists.com"
    {:error, :nxdomain} = Favicon.fetch(url)
  end

  test "try fetch favicon from site without favicon" do
    url = "http://lasmastarn.se"
    assert {:error, :favicon_missing} == Favicon.fetch(url)
  end

  test "fetch 404 url" do
    url = "https://google.com/404"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://google.com/images/branding/product/ico/googleg_lodp.ico"
  end

  test "fetch a non html url" do
    url = "https://google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://google.com/images/branding/product/ico/googleg_lodp.ico"
  end

  # TODO: Add a test to see how it behaves with a different port (not 80)
  # TODO: Add a test to see hwo it behaves with subdomains.
end
