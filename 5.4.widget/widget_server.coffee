pio           = require('socket.io').listen 8081
sioclient    = require 'socket.io-client'
widgetScript = require('fs').readFileSync 'widget_client.js' #ここを CoffeeScript にできなかった
url          = require 'url'

totals = require('redis').createClient()

io.configure ->
  io.set 'resource', '/loc'
  io.enable 'browser client gzip'

sioclient.builder io.transports(), (err, siojs) ->
  return if err
  io.static.add '/widget.js', (path, callback) ->
    callback null, new Buffer "#{siojs};#{widgetScript}"

io.sockets.on 'connection', (socket) ->
    origin = if socket.handshake.xdomain then url.parse(socket.handshake.headers.origin).hostname else 'local'
    socket.join origin

    totals.incr origin, (err, total) ->
      io.sockets.to(origin).emit 'total', total

    socket.on 'disconnect', ->
      totals.decr origin, (err, total) ->
        io.sockets.to(origin).emit 'total', total
