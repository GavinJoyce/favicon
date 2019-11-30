defmodule FaviconTest do
  use ExUnit.Case, async: true
  doctest Favicon

  test "fetch favicon url from google.com" do
    url = "http://www.google.com"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, "google.com/favicon.ico")
  end

  test "fetch favicon url from facebook.com (http -> https)" do
    url = "http://www.facebook.com"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, ".ico")
  end

  test "fetch favicon url from hexdocs.pm (missing link tag)" do
    url = "https://hexdocs.pm/ecto/Ecto.html"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://hexdocs.pm/favicon.png"
  end

  # https://github.com/philss/floki/issues/235
  # test "fetch absolute favicon url in link tag" do
  #   url = "https://github.com"
  #   {:ok, result} = Favicon.fetch(url)
  #   assert result == "https://github.com/fluidicon.png"
  # end

  test "fetch favicon url from another domain" do
    url = "http://www.phoenixframework.org/"
    {:ok, result} = Favicon.fetch(url)
    assert result == "http://www.phoenixframework.org/favicon.ico"
  end

  test "try fetch favicon url from non existent domain" do
    url = "http://thisurldoesnotexists.com"
    {:error, :nxdomain} = Favicon.fetch(url)
  end

  test "try fetch favicon url from site without favicon" do
    url = "http://lasmastarn.se"
    assert {:error, :favicon_missing} == Favicon.fetch(url)
  end

  test "try fetch favicon url from 404 url" do
    url = "https://google.com/404"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, "google.com/favicon.ico")
  end

  test "fetch favicon url from a non html url" do
    url = "https://google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, "google.com/favicon.ico")
  end

  test "fetch favicon url from an url not specifying http or https in favicon url" do
    url = "http://stackoverflow.com"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, "favicon.ico?v=4f32ecc8f43d")

  end

  test "fetch favicon where 302 redirect happen" do
    url = "http://tv4.se"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://www.tv4.se/assets/favicon-63417250ec30e676f25c63030de831fb.ico"
  end

  test "fetch from https://twitter.com" do
    url = "https://twitter.com"
    {:ok, result} = Favicon.fetch(url)
    assert String.ends_with?(result, "favicon.svg")
  end

  # TODO: Add a test to see how it behaves with a different port (not 80)
  # TODO: Add a test to see hwo it behaves with subdomains.
end
