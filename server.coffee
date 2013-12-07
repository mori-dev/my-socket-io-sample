http = require 'http'
path = require 'path'
_    = require 'underscore'

pages = [
  {route: '',             output: 'ホームページ'},
  {route: 'about',        output: 'アバウトページ'},
  {route: 'another page', output: -> "ルートは #{@route}"}
]

httpServer = http.createServer (req, res) ->

  currentUrl = path.basename(decodeURI(req.url))

  _.each pages, (page) ->
    if page.route is currentUrl
      res.writeHead 200, {'Content-Type': 'text/html'}
      res.end(_.result page, 'output')
  unless res.finished
    res.writeHead 404
    res.end '404 エラー'

httpServer.listen 8081
