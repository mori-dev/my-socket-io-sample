http     = require 'http'
fs       = require 'fs'
profiles = require './profiles'
buildXml = require './buildXml'
index    = fs.readFileSync 'namespace-socketio-index.html'
url      = require 'url'
path     = require 'path'

io = require('socket.io').listen(
  httpServer = http.createServer (req, res) ->
    lookup = path.basename(decodeURI(req.url)) or 'namespace-socketio-index.html'
    switch lookup
      when 'namespace-socketio-index.html'
        res.writeHead 200, 'text/html'
        res.end index
      when 'coffee-script.js'
        res.writeHead 200, 'text/javascript'
        res.end fs.readFileSync 'coffee-script.js'
      when 'namespace-socketio-client.coffee'
        res.end fs.readFileSync 'namespace-socketio-client.coffee'
      else
        res.end
  httpServer.listen 8081
)

io.of('/json').on 'connection', (socket) ->
  socket.on 'profiles', (cb) ->
    cb Object.keys(profiles)
  socket.on 'profile', (profile) ->
    socket.emit 'profile', profiles[profile]

io.of('/xml').on 'connection', (socket) ->
  socket.on 'profile', (profile) ->
    socket.emit 'profile', buildXml(profiles[profile])
