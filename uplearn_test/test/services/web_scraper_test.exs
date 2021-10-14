defmodule WebScraperTest do


  alias Floki
  alias Services.WebScraper

  import Tesla.Mock

  use ExUnit.Case

  @valid_url "http://example.com/hello"
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
  @invalid_html "invalid_html"

  setup do
    mock(fn
      %{method: :get, url: "http://example.com/"} ->
        %Tesla.Env{status: 200, body: @valid_html}

    end)

    :ok
  end

  describe "get_content_by_url/1" do
    test "should return :ok status code and his html" do
      assert {:ok, %Tesla.Env{} = env} = WebScraper.get_content_by_url(@valid_url)
      assert env.status == 200
      assert env.body == @valid_html
    end
  end

  describe "valid_url?/1" do
    test "should return :ok when url is valid" do
      assert :ok == WebScraper.valid_url?(@valid_url)
    end

    test "should return :error when url is invalid" do
      assert :error == WebScraper.valid_url?(@invalid_url)
    end
  end

  describe "get_links_from_tag_a/1" do
    test "should return correct links from <a> href" do
      {:ok, links} = WebScraper.get_links_from_tag_a(@valid_html)
      assert links == ["www.google.com", "facebook.com", "linkedin.com"]
    end
  end

  describe "get_links_from_tag_img/1" do
    test "should return correct links from <img> src" do
      {:ok, links} = WebScraper.get_links_from_tag_img(@valid_html)

      assert links == [
               "https://elixir-lang.org/images/logo/logo.png",
               "https://miro.medium.com/max/2000/1*WvDl2WlPs7cR8TTBvrjpyw.png"
             ]
    end
  end

  describe "fetch/1" do
    test "should return corret map of assets and links when receives a valid url" do
      {:ok, resources} = WebScraper.fetch(@valid_url)

      assert resources == %{
        assets: ["www.google.com", "facebook.com", "linkedin.com"],
        links: [
          "https://elixir-lang.org/images/logo/logo.png",
          "https://miro.medium.com/max/2000/1*WvDl2WlPs7cR8TTBvrjpyw.png"
        ]
      }
    end
  end

end
