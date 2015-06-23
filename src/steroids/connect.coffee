class Connect

  @ParseError: class ParseError extends steroidsCli.SteroidsError

  constructor:(options={}) ->
    @port = options.port
    @showConnectScreen = options.connectScreen
    @watch = options.watch
    @livereload = options.livereload
    @watchExclude = options.watchExclude
    @cordova = options.cordova

    @prompt = null

  run: () =>
    Updater = require "./Updater"
    updater = new Updater
    updater.check
      from: "connect"

    return new Promise (resolve, reject) =>
      Simulator = require "./Simulator"
      simulatorForKillingIt = new Simulator
      simulatorForKillingIt.killall()

      Genymotion = require "./emulate/genymotion"
      genymotionForKillingIt = new Genymotion
      genymotionForKillingIt.killall()
      .then ->
        steroidsCli.debug "Killed genymotion"

      Android = require "./emulate/android"
      androidForKillingIt = new Android
      androidForKillingIt.killall()
      .then ->
        steroidsCli.debug "Killed android"

      ProjectFactory = require "./project/ProjectFactory"
      @project = ProjectFactory.create()

      @project.push().then =>
        @startServer()
      .then =>
        resolve()
      .catch (error) =>
        reject error

  startServer: ()=>
    return new Promise (resolve, reject) =>
      Server = require "./Server"
      BuildServerFactory = require "./servers/BuildServerFactory"

      @server = Server.start
        port: @port
        callback: ()=>
          global.steroidsCli.server = @server

          @buildServer = BuildServerFactory.create
            server: @server
            path: "/"
            port: @port
            livereload: @livereload
            cordova: @cordova

          @server.mount(@buildServer)

          @startPrompt()
          .then resolve

  startPrompt: ()=>
    return new Promise (resolve, reject) =>
      Prompt = require "./Prompt"
      @prompt = new Prompt
        context: @
        buildServer: @buildServer

      if @showConnectScreen
        QRCode = require "./QRCode"
        QRCode.showLocal
          port: @port

        steroidsCli.debug "connect", "Waiting for the client to connect, scan the QR code visible in your browser ..."

      refreshLoop = ()=>
        activeClients = 0;

        for ip, client of @buildServer.clients
          delta = Date.now() - client.lastSeen

          if (delta > 4000)
            delete @buildServer.clients[ip]
            steroidsCli.debug "connect", "Client disconnected: #{client.ipAddress} - #{client.userAgent}"
          else if client.new
            activeClients++
            client.new = false

            steroidsCli.debug "connect", "New client: #{client.ipAddress} - #{client.userAgent}"
          else
            activeClients++

      setInterval refreshLoop, 1000

      if @watch
        @startWatcher()
        .then resolve
      else
        resolve()

  startWatcher: ()=>
    return new Promise (resolve, reject) =>
      Watcher = require "./fs/watcher"
      appWatcher = new Watcher
        path: "app"
        ignored: @watchExclude

      wwwWatcher = new Watcher
        path: "www"
        ignored: @watchExclude

      configWatcher = new Watcher
        path: "config"
        ignored: @watchExclude

      ProjectFactory = require "./project/ProjectFactory"
      project = ProjectFactory.create()

      canBeLiveReload = true
      shouldMake = false
      isMaking = false

      doMake = =>
        new Promise (resolve, reject)=>
          steroidsCli.debug "connect", "doMake"
          project.make().then =>
            steroidsCli.debug "connect", "doMake succ"
            resolve()
          .catch (error)=>
            steroidsCli.debug "connect", "doMake fail"
            if error.message.match /Parse error/ # coffee parser errors are of class Error
              console.log "Error parsing application configuration files: #{error.message}"
              reject new ParseError error.message
            else
              reject error

      doLiveReload = =>
        new Promise (resolve, reject)=>
          steroidsCli.debug "connect", "doLiveReload"

          steroidsCli.log "Notified all connected devices to refresh"

          @buildServer.triggerLiveReload()

          steroidsCli.debug "connect", "doLiveReload succ"
          resolve()

      doFullReload = =>
        new Promise (resolve, reject)=>
          steroidsCli.debug "connect", "doFullReload"
          project.package()
          .then =>
            steroidsCli.debug "connect", "doFullReload succ"
            canBeLiveReload = true
            @prompt.refresh()
            resolve()

      maker = =>
        return if isMaking
        return unless shouldMake

        shouldMake = false
        isMaking = true

        steroidsCli.log
          message: "Detected change, running make ..."
          refresh: false
        doMake()
        .then =>
          steroidsCli.debug "connect", "livereload: #{@livereload} and can be livereloaded: #{canBeLiveReload}"
          if @livereload and canBeLiveReload
            doLiveReload()
          else
            doFullReload()
        .then =>
          isMaking = false

      setInterval maker, 100

      appWatcher.on ["add", "change", "unlink"], (path)=>
        shouldMake = true

      wwwWatcher.on ["add", "change", "unlink"], (path)=>
        shouldMake = true

      configWatcher.on ["add", "change", "unlink"], (path)=>
        canBeLiveReload = false
        shouldMake = true

      userPaths = if steroidsCli.options.argv.watch
        [].concat(steroidsCli.options.argv.watch)
      else
        []

      for userPath in userPaths
        do (userPath) =>
          watcher = new Watcher
            path: userPath
            ignored: @watchExclude

          watcher.on ["add", "change", "unlink"], (path)=>
            shouldMake = true

      resolve()


module.exports = Connect
