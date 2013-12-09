http = require 'http'
path = require 'path'
fs   = require 'fs'

mimeTypes =
  '.js': 'text/javascript'
  '.html': 'text/html'
  '.css': 'text/css'

httpServer = http.createServer (request, response) ->

  lookup = path.basename(decodeURI(request.url)) or 'index.html'
  file = "streaming-contents/#{lookup}"

  fs.exists file, (exists) ->

    unless exists
      response.writeHead 404
      response.end 'ページがみつかりません'

    headers = { 'Content-Type': "#{mimeTypes[path.extname(file)]};charset=utf-8" }

    stream = fs.createReadStream(file).once 'open', ->
      response.writeHead 200, headers
      @pipe response
    .once 'error', (error) ->
      console.log(error)
      response.writeHead 500
      response.end 'サーバエラー'


httpServer.listen 8082
