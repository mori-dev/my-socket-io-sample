io           = require('socket.io').listen 8081
sioclient    = require 'socket.io-client'
widgetScript = require('fs').readFileSync 'widget_client.js' #ここを CoffeeScript にできなかった
url          = require 'url'

totals = {};

io.configure ->
  io.set 'resource', '/loc'
  io.enable 'browser client gzip'

sioclient.builder io.transports(), (err, siojs) ->
  return if err
  io.static.add '/widget.js', (path, callback) ->
    callback null, new Buffer "#{siojs};#{widgetScript}"

io.sockets.on 'connection', (socket) ->
    origin = if socket.handshake.xdomain then url.parse(socket.handshake.headers.origin).hostname else 'local'
    totals[origin] = (totals[origin]) or 0
    totals[origin] += 1
    socket.join origin

    io.sockets.to(origin).emit('total', totals[origin])
    socket.on 'disconnect', ->
      totals[origin] -= 1
      io.sockets.to(origin).emit('total', totals[origin])
