defmodule Helpers.TagsFinder do

  use ExUnit.Case

  alias Floki

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
end
