defmodule WebScraperTest do

  use ExUnit.Case

  alias Services.WebScraper

  import Tesla.Mock

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

end
