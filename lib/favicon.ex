defmodule Favicon do
  def fetch(url) do
    HTTPoison.start
    hackney = [follow_redirect: true]
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"

    case HTTPoison.get(domain, [], [hackney: hackney]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        find_favicon_url(domain, body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404 not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp find_favicon_url(domain, body) do
    tag = find_favicon_link_tag(body)
    if tag do
      {"link", attrs, _} = tag
      {"href", path} = Enum.find(attrs, fn({name, _}) ->
        name == "href"
      end)
      cond do
        String.starts_with?(path, domain) ->
          {:ok, "#{path}"} # the favicon is an absolute path
        String.starts_with?(path, "/") ->
          {:ok, "#{domain}#{path}"} # relative path starting with /
        true ->
          {:ok, "#{domain}/#{path}"}
      end
    else
      find_favicon_in_root(domain)
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

  defp find_favicon_in_root(domain) do
    favicon_url = "#{domain}/favicon.ico"
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
