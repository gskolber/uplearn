defmodule WebScraperTest do
  alias Floki
  alias Services.WebScraper

  import Tesla.Mock

  use ExUnit.Case

  @url_with_no_tags "http://no-tags-here.com"
  @valid_url "http://example.com/"
  @invalid_url "this not is an html"
  @invalid_url_domain "http://this-just-is-a-failed-example.com"
  @valid_html """
  <html>
    <title>

    </title>
    <body>
        <a href="www.google.com">First Link</a>
        <a href="facebook.com">Second Link</a>
        <a href="linkedin.com">Third Link</a>


        <img src="https://elixir-lang.org/images/logo/logo.png">
        <img src="https://miro.medium.com/max/2000/1*WvDl2WlPs7cR8TTBvrjpyw.png">
    </body>
  </html>
  """
  @html_with_no_tags """
  <!DOCTYPE html>
  <html>
    <head>
        <meta charset='utf-8'>
        <meta http-equiv='X-UA-Compatible' content='IE=edge'>
        <title>Page Title</title>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <link rel='stylesheet' type='text/css' media='screen' href='main.css'>
        <script src='main.js'></script>
    </head>
    <body>
        <p>Hello World</p>
        <h1>Any title</h1>
        <button>Click me</button>

    </body>
  </html>
  """

  setup do
    mock(fn
      %{method: :get, url: @valid_url} ->
        %Tesla.Env{status: 200, body: @valid_html}

      %{method: :get, url: @invalid_url_domain} ->
        {:error, :nxdomain}

      %{method: :get, url: @url_with_no_tags} ->
        %Tesla.Env{status: 200, body: @html_with_no_tags}
    end)

    :ok
  end

  describe "fetch/1" do
    test "should return corret map of assets and links when receives a valid url" do
      {:ok, resources} = WebScraper.fetch(@valid_url)

      assert resources == %{
               assets: [
                 "https://elixir-lang.org/images/logo/logo.png",
                 "https://miro.medium.com/max/2000/1*WvDl2WlPs7cR8TTBvrjpyw.png"
               ],
               links: ["www.google.com", "facebook.com", "linkedin.com"]
             }
    end

    test "should return an :invalid_url when the url was invalid" do
      assert {:error, :invalid_url} == WebScraper.fetch(@invalid_url)
    end

    test "should return an error when domain is invalid" do
      assert {:error, :nxdomain} == WebScraper.fetch(@invalid_url_domain)
    end

    test "should return a empty array when does not exists <a> or <img> tags" do
      assert {:ok,
              %{
                assets: [],
                links: []
              }} == WebScraper.fetch(@url_with_no_tags)
    end
  end
end
