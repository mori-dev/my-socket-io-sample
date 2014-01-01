http       = require 'http'
clientHtml = require('fs').readFileSync 'index.html'

server = http.createServer (request, response) ->
  response.writeHead 200, {'Content-Type': 'text/html'}
  response.end clientHtml
server.listen 8082
