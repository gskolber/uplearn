
# UplearnTest

  

Write a function fetch(url) that fetches the page corresponding to the url and returns an object
that has the following attributes:
- assets - an array of urls present in the <img> tags on the page
- links - an array of urls present in the <a> tags on the page

  

## How use

```bash
mix deps.get
mix deps.compile
mix test
```

  
## Dependencies
* [Floki](https://hexdocs.pm/floki/Floki.html) - Used as HTTP Parser
* [Tesla](https://hexdocs.pm/tesla/readme.html) - Used to HTTP Consumption