defmodule FaviconTest do
  use ExUnit.Case
  doctest Favicon

  test "fetch nordea.se favicon" do
    url = "http://www.nordea.se"
    {:ok, result} = Favicon.fetch(url)
    assert result == "#{url}/favicon.ico"
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

  test "try fetch with non existent domain" do
    url = "http://thisurldoesnotexists.com"
    {:error, :nxdomain} = Favicon.fetch(url)
  end

  test "try fetch favicon from site without favicon" do
    url = "http://lasmastarn.se"
    assert {:error, :favicon_missing} == Favicon.fetch(url)
  end

  test "fetch non authorized url" do
    url = "https://trello.com/b/OeZ2BmXa/blackdocio"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://trello.com/favicon.ico"
  end

  test "fetch 404 url" do
    url = "https://trello.com/molasricny"
    {:ok, result} = Favicon.fetch(url)
    assert result == "https://trello.com/favicon.ico"
  end

  test "fetch a non html url" do
    url = "http://a-eon.biz/PDF/News_Release_Developer.pdf"
    {:ok, result} = Favicon.fetch(url)
    assert result == "http://a-eon.biz/images/favicon.png"
  end

  # TODO: Add a test to see how it behaves with a different port (not 80)
  # TODO: Add a test to see hwo it behaves with subdomains.
end
