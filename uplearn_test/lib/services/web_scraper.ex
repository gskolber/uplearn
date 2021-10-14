defmodule Services.WebScraper do

  use Tesla

  def fetch(url) do
    with {:valid_url} <- validate_url(url),
    {:ok, response} <- get_content_from_url(url),
    {:ok, links_from_a_tag} <- get_links_from_tag_a(response.body),
    {:ok, links_from_img_tag} <- get_links_from_tag_img(response.body)
     do
      {:ok, %{
        assets: links_from_img_tag,
        links: links_from_a_tag
      }}
    else
      {:invalid_url} -> {:error, :invalid_url}
      {:error, :nxdomain} -> {:error, :nxdomain}

    end

  end

  defp validate_url(url) do
    uri = URI.parse(url)
    case uri.scheme != nil && uri.host =~ "." do
      true -> {:valid_url}
      false -> {:invalid_url}
    end
  end

  defp get_content_from_url(url) do
    get(url)
  end

  defp get_links_from_tag_a(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      links = document |> Floki.find("a") |> Floki.attribute("href")
      {:ok, links}
    end
  end

  defp get_links_from_tag_img(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      links = document |> Floki.find("img") |> Floki.attribute("src")
      {:ok, links}
    end
  end
end
