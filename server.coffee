http = require 'http'

httpServer = http.createServer (req, res) ->
  res.writeHead 200, { 'Content-Type': 'text/html' }
  res.end 'Hello World'

httpServer.listen 8081
