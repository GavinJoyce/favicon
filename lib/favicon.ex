defmodule Favicon do
  def fetch(url) do
    HTTPoison.start
    hackney = [follow_redirect: true]
    case HTTPoison.get(url, [], [hackney: hackney]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        find_favicon_url(url, body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404 not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp find_favicon_url(url, body) do
    tag = find_favicon_link_tag(body)
    if tag do
      {"link", attrs, _} = tag
      {"href", path} = Enum.find(attrs, fn({name, _}) ->
        name == "href"
      end)
      {:ok, "#{url}#{path}"}
    else
      find_favicon_in_root(url)
    end
  end

  defp find_favicon_link_tag(body) do
    links = Floki.find(body, "link")
    Enum.find(links, fn({"link", attrs, _}) ->
      Enum.any?(attrs, fn({name, value}) ->
        name == "rel" && String.contains?(value, "icon") && !String.contains?(value, "-icon-")
      end)
    end)
  end

  defp find_favicon_in_root(url) do
    uri = URI.parse(url)
    favicon_url = "#{uri.scheme}://#{uri.host}/favicon.ico"
    case HTTPoison.get(favicon_url) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, favicon_url}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :favicon_missing}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
