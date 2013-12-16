http       = require 'http'
fs         = require 'fs'
clientHtml = fs.readFileSync 'simple-socketio-server-client.html'

plainHttpServer = http.createServer (req, res) ->

  res.writeHead 200, { 'Content-Type': 'text/html' }
  res.end clientHtml

plainHttpServer.listen 8081

io = require('socket.io').listen plainHttpServer

io.set 'origins', ['localhost:8081', '127.0.0.1:8081']

io.sockets.on 'connection', (socket) ->
  socket.on 'message', (msg) ->
    if msg is 'Hello'
      socket.send 'socket.io！'
