paths = require "./paths"
util = require "util"
express = require "express"
json = require "express-json"
http = require "http"

class Server

  @start: (options={}) =>
    selectedPort = options.port

    errorCb = (err)=>
      if err.message.match /EADDRINUSE/
        util.log "ERROR: Port #{selectedPort} is already in use. You probably have already have another `steroids` command running on that port."
        process.exit 1
      else
        throw err

    server = new Server
      port: selectedPort
      path: "/"
      errorCallback: errorCb

    server.listen ()=>
      util.log "The server has now been started on port #{selectedPort}"
      options.callback()

    return server


  constructor: (@options) ->
    throw "path must be specified" unless @options.path

    @app = express()

    @app.use express.static(paths.staticFiles)
    @app.use json()

    @port = @options.port

  port: undefined

  setRoutes: () =>
    console.log "Server setRoutes"

    @app.get "*", (req, res) ->
      util.log "No route for path: #{req.path}"
      res.send 404

  listen: (callback=->) =>
    throw "port must be set in constructor options before calling listen" unless @options.port

    @server = http.createServer(@app)
    @server.on "listening", callback
    @server.on "error", @options.errorCallback
    @server.listen @options.port

  mount: (appToMount) =>
    appToMount.setRoutes()
    @app.use appToMount.options.path, appToMount.app

  interfaces: =>
    os = require 'os'

    interfaces = os.networkInterfaces()
    addresses = []
    for k of interfaces
      unless k.indexOf("lo") == 0 or k.indexOf("Loopback") == 0
        for k2 of interfaces[k]
          address = interfaces[k][k2]
          if address.family == 'IPv4' and address.address.indexOf("169.254.") == -1
            addresses.push { ip: address.address, name: k }

    return addresses


  ipAddresses: =>
    @interfaces().map((e) -> return e.ip )

module.exports = Server
