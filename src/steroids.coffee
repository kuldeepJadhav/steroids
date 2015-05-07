global.Promise = require("bluebird")
global.argv = require('optimist').argv

path = require "path"
util = require "util"
open = require "open"
fs = require "fs"
chalk = require "chalk"

Help = require "./steroids/Help"
paths = require "./steroids/paths"

Promise.onPossiblyUnhandledRejection (e, promise) ->
  throw e


class SteroidsError extends Error
  constructor: (message)->
    Error.call @
    Error.captureStackTrace(@, @constructor)
    @name = @constructor.name
    @message = message

class Steroids

  SteroidsError: SteroidsError
  PlatformError: class PlatformError extends SteroidsError

  globals:
    genymotion: null
    simulator: null

  constructor: (@options = {}) ->
    Version = require "./steroids/version/version"
    Config = require "./steroids/project/config"

    @version = new Version
    @pathToSelf = process.argv[1]
    @config = new Config
    @projectType = if @options.argv.cordova or @isIonicProject() or @isCordovaProject()
      "cordova"
    else
      "steroids"
    @platform = @options.argv.platform || "ios"

    @debugEnabled = @options.debug
    @debugMessages = []

    @connect = null

  isIonicProject: ->
    fs.existsSync paths.cordovaSupport.ionicProject

  isCordovaProject: ->
    fs.existsSync paths.cordovaSupport.configXml

  host:
    os:
      isOSX: ->
        process.platform == "darwin"
      isWindows: ->
        process.platform == "win32"
      isLinux: ->
        process.platform == "linux"
      osx:
        isYosemite: ->
          require("os").release().match(/^14\./)?

  readApplicationConfig: ->
    applicationConfig = paths.application.configs.application

    if fs.existsSync(applicationConfig)
      contents = fs.readFileSync(applicationConfig).toString()

    return contents

  detectSteroidsProject: ->
    return fs.existsSync(paths.application.configDir) and (fs.existsSync(paths.application.appDir) or fs.existsSync(paths.application.wwwDir))

  debug: (options = {}, other) =>
    message = if other?
      options + ": " + other
    else if options.constructor.name == "String"
      options
    else
      options.message

    message = "#{new Date()} #{message}"
    steroidsCli.debugMessages.push message

    if steroidsCli.options.debug
      process.stdout.cursorTo(0) if process.stdout.cursorTo?
      console.log "[DEBUG]", message


  log: (options) =>

    [tagMessage, message, refresh, prepend, newline] = if options.constructor.name == "String"
      [undefined, options,true, true, true]
    else
      [options.tag, options.message, (options.refresh != false), (options.prepend != false), (options.newline != false)]

    tag = if tagMessage
      "[#{tagMessage}] "
    else
      ""

    prefix = if prepend and @connect?.prompt?
      prepend = "\n"
    else
      ""

    suffix = if newline
      suffix = "\n"
    else
      ""

    util.print "#{prefix}#{tag}#{message}#{suffix}"

    if refresh and @connect?.prompt?
      @connect?.prompt?.refresh()

  ensureProjectIfNeededFor: (command, otherOptions) ->
    commands = [
      "push"
      "make"
      "package"
      "connect"
      "update"
      "generate"
      "deploy"
      "debug"
      "emulate"
      "data"
    ]

    if command in commands
      return if @detectSteroidsProject() or @projectType is "cordova"

      steroidsCli.log "Error: command '#{command}' requires to be run in a Steroids project directory."
      process.exit(1)

  execute: =>
    [firstOption, otherOptions...] = argv._

    if argv.version
      firstOption = "version"

    if firstOption not in ["emulate", "debug"] and argv.help
      firstOption = "usage"

    @ensureProjectIfNeededFor(firstOption, otherOptions)

    if firstOption in ["connect", "create"]
      Help.logo() unless argv.noLogo

    Login = require("./steroids/Login")
    if firstOption in ["connect", "deploy", "simulator", "logout"]
      unless Login.authTokenExists()
        console.log """

        You must be logged in, log in with:

        \t$ steroids login

        """
        process.exit 1

    switch firstOption

      when "data"
        Data = require "./steroids/Data"

        data = new Data
        switch otherOptions[0]
          when "init"
            data.init()

          #TODO impl
          # when "reset"
          #   providers = new Providers
          #   providers.removeDatabase()

          when "manage"
            data.manage()

          when "sync"
            data.sync()

          else
            Help.dataUsage()

      when "version"
        steroidsCli.version.run()

      when "create"
        options =
          targetDirectory: otherOptions[0]

        unless options.targetDirectory
          steroidsCli.log "Usage: steroids create <directoryName>"
          process.exit(1)

        fullPath = path.join process.cwd(), options.targetDirectory
        steroidsCli.debug "Creating a new project in #{chalk.bold fullPath}..."

        if fs.existsSync fullPath
          Help.error()
          steroidsCli.log "Directory #{chalk.bold(options.targetDirectory)} already exists. Remove it to continue."
          process.exit(1)

        prompts = []

        unless argv.type
          typePrompt =
            type: "list"
            name: "type"
            message: "What do you want to create?"
            choices: [
              { name: "Multi-Page Application (Supersonic default)", value: "mpa" }
              { name: "Single-Page Application (for use with other frameworks)", value: "spa"}
              { name: "Module Development Harness (to develop custom modules)", value: "module"}
            ]
            default: "mpa"

          prompts.push typePrompt

        unless argv.language
          languagePrompt =
            type: "list"
            name: "language"
            message: "Do you want your project to be generated with CoffeeScript or JavaScript files?"
            choices: [
              { name: "CoffeeScript", value: "coffee" }
              { name: "JavaScript", value: "js"}
            ]
            default: "coffee"

          prompts.push languagePrompt

        inquirer = require "inquirer"
        inquirer.prompt prompts, (answers) =>
          options.type = argv.type || answers.type
          options.language = argv.language || answers.language

          ProjectCreator = require("./steroids/ProjectCreator")
          projectCreator = new ProjectCreator options

          projectCreator.run().then ->
            projectCreator.update().then ->
              steroidsCli.log """
                #{chalk.bold.green('\nSuccesfully created a new Steroids project!')}

                Run #{chalk.bold("cd "+ options.targetDirectory)} and then #{chalk.bold('steroids connect')} to start building your app!
              """
            .catch (err) ->
              steroidsCli.log err.message
              process.exit 1

      when "push"
        ProjectFactory = require "./steroids/project/ProjectFactory"
        project = ProjectFactory.create()
        project.push()
        .then ->
          steroidsCli.debug "steroids make && steroids package ok."

      when "make"
        ProjectFactory = require "./steroids/project/ProjectFactory"
        project = ProjectFactory.create()
        project.make()

      when "package"
        PackagerFactory = require "./steroids/packager/PackagerFactory"
        packager = PackagerFactory.create()

        packager.create()

      when "module"
        runModuleCommand = require "./steroids/module/runCommand"
        [ cmd, params... ] = otherOptions

        runModuleCommand(cmd, argv)
          .catch (error) ->
            if error.message.match /Please run again with/
              console.log "Error:", error.message
            else if error.message.match /Cannot find module/
              console.log "Error: Please run `steroids module init` first."
            else
              throw error

      when "simulator"
        console.log "see: steroids emulate"

      when "connect"

        Connect = require "./steroids/connect"

        port = if argv.port
          argv.port
        else
          4567

        watchExclude = if argv.watchExclude
          argv.watchExclude.split(",")
        else
          []

        livereloadEnabled = argv.livereload
        watchEnabled = !(argv.watch is false)

        showConnectScreen = true
        if argv['connect'] == false or argv['qrcode'] == false
          showConnectScreen = false

        @connect = new Connect
          port: port
          watch: watchEnabled
          livereload: livereloadEnabled
          watchExclude: watchExclude
          connectScreen: showConnectScreen

        @connect.run()
        .then =>
          Help = require "./steroids/Help"
          Help.connect()

          chalk = require "chalk"
          console.log "\nHit #{chalk.green("[enter]")} to push updates, type #{chalk.bold("help")} for usage"

          @connect.prompt.connectLoop()
        .catch (error)=>
          if error.message.match /Parse error/ # coffee parser errors are of class Error
            console.log "Error parsing application configuration files: #{error.message}"
            console.log "Fix the syntax error and re-run the steroids connect command"
          else
            throw error

      when "update"
        Updater = require "./steroids/Updater"
        updater = new Updater
          verbose: false

        updater.check(
          from: "update"
        ).then( ->
          Npm = require "./steroids/Npm"
          npm = new Npm
          npm.install()
        ).then( ->
          Bower = require "./steroids/Bower"
          bower = new Bower
          bower.update()
        )

      when "generate"
        [generatorType, generatorArgs...] = otherOptions

        unless generatorType?
          Help.listGenerators()
          process.exit 0

        Generators = require "./steroids/Generators"

        generatorOptions =
          name: generatorArgs[0]
          otherOptions: generatorArgs

        unless Generators[generatorType]
          console.log "No such generator: #{generatorType}"
          process.exit(1)

        generator = new Generators[generatorType](generatorOptions)

        try
          generator.generate()
        catch error
          throw error unless error.fromSteroids?

          util.log "ERROR: #{error.message}"
          process.exit 1


      when "login"
        Login = require "./steroids/Login"

        Help.logo()

        if Login.authTokenExists()
          util.log "Already logged in."
          return

        port = if argv.port
          argv.port
        else
          13303

        login = new Login
          port: port

        login.run().then () =>
          Help.loggedIn()
          process.exit(0)

      when "logout"
        Logout = require "./steroids/logout"
        logout = new Logout
        logout.run().then () ->
          Help.logo()
          Help.loggedOut()

      when "deploy"
        Deploy = require "./steroids/Deploy"

        deploy = new Deploy
          allowConfigCreation: argv.allowConfigCreation

        deploy.run().then () ->
          steroidsCli.log "Deployment complete"
          Help.deployCompleted()
        .catch (error)->
          Help.error()
          steroidsCli.log error


      when "safari"
        console.log "see: steroids debug"

      when "emulate"
        PortChecker = require "./steroids/PortChecker"
        connectServer = new PortChecker
          port: 4567

        connectServer.open().then ->

          switch otherOptions[0]
            when "android"
              Android = require "./steroids/emulate/android"
              android = new Android()
              android.run().catch (error) ->
                Help.error()
                steroidsCli.log
                  message: error.message

            when "ios"
              Simulator = require "./steroids/Simulator"
              simulator = new Simulator()

              if argv.devices
                simulator.getDevicesAndSDKs()
                .then (devices)->
                  for device in devices
                    steroidsCli.log "#{device.name}#{chalk.grey('@'+device.sdks)}"
              else
                simulator.run(
                  device: argv.device
                ).catch (error) ->
                    Help.error()
                    steroidsCli.log
                      message: error.message

            when "genymotion"
              Genymotion = require "./steroids/emulate/genymotion"
              genymotion = new Genymotion()
              genymotion.run().catch (error) ->
                Help.error()
                steroidsCli.log
                  message: error.message

            else
              Usage = require "./steroids/usage"
              usage = new Usage
              usage.emulate()
        .catch (error) ->
          Help.error()
          steroidsCli.log
            message: "Please run #{chalk.bold('steroids connect')} before running emulators."

      when "debug"

        switch otherOptions[0]
          when "safari"
            SafariDebug = require "./steroids/SafariDebug"
            safariDebug = new SafariDebug
            location = argv.location

            if location?
              safariDebug.open(location)
                .catch (error) ->
                  Help.error()
                  steroidsCli.log
                    message: error.message
            else
              safariDebug.listViews().then (views) -> # TODO: Put print logic in SafariDebug?
                steroidsCli.log
                  message: chalk.bold "Available views:"
                  refresh: false
                steroidsCli.log
                  message: views.join("\n")
              .catch (error) ->
                Help.error()
                steroidsCli.log
                  message: error.message

          when "chrome"
            ChromeDebug = require "./steroids/debug/chrome"
            chromeDebug = new ChromeDebug
            chromeDebug.run().then ->
              steroidsCli.log "Opened chrome://inspect in Google Chrome"

          when "weinre"
            console.log "Not implemented yet"

          else
            Usage = require "./steroids/usage"
            usage = new Usage
            usage.debug()

      when "log"

        switch otherOptions[0]
          when "steroids"
            SteroidsLog = require "./steroids/log/steroids_log"
            steroidsLog = new SteroidsLog
            steroidsLog.run()

          when "logcat"
            LogCat = require "./steroids/log/logcat"
            logCat = new LogCat

            if argv.tail
              logCat.run
                tail: true
            else
              logCat.run()
              .then (logLines) ->
                for line in logLines
                  do (line) ->
                    steroidsCli.log line
              .catch (error) ->
                Help.error()
                steroidsCli.log
                  message: error.message

          else
            Usage = require "./steroids/usage"
            usage = new Usage
            usage.log()

      when "about"
        Banner = require("./steroids/banner/banner")
        Banner.dolan()

      when "__watch"

        Watcher = require "./steroids/fs/watcher"
        watcher = new Watcher
          path: otherOptions[0]

        for event in ["change", "add", "unlink", "addDir", "unlinkDir", "error"]
          do (event) ->
            watcher.on event, (path, stats) ->
              console.log event, path, stats

      when "__banner"
        # devroids __banner steroids --font Graffiti --horizontalLayout 'universal smushing'
        Banner = require("./steroids/banner/banner")
        banner = new Banner
          font: argv.font
          horizontalLayout: argv.horizontalLayout
          verticalLayout: argv.verticalLayout



        if argv.all
          banner.availableFonts()
          .then (fonts) ->
            for font in fonts
              banner.font = font
              console.log font
              console.log banner.makeSync otherOptions.join " "
        else
          text = banner.makeSync otherOptions.join " "

          colorized = if argv.color
            chalk[argv.color](text)
          else
            text

          if argv.speed
            Banner.print(colorized, argv.speed)
          else
            console.log colorized

      else
        Usage = require "./steroids/usage"
        usage = new Usage
          extended: argv.help?

        usage.run()

module.exports =
  run: ->
    domain = require "domain"
    d = domain.create()

    d.on 'error', (err) ->

      if err.name == "PlatformError"
        steroidsCli?.log "Operating system not supported"
      else
        console.log "Steroids Error"

        console.log """
        Debug Log:
        #{steroidsCli?.debugMessages?.join("\n")}

        Error with: steroids #{process.argv[2]}

        #{err.stack}

        Runtime information:

        \tplatform: #{process.platform}\tnode path: #{process.execPath}
        \tarch: #{process.arch}\t\tnode version: #{process.version}

        \tcwd: #{process.cwd()}

        Please send the above output to contact@appgyver.com
          (Also if possible, re-run the same command with --debug and please send that output too)
        """

    d.run ->
      global.steroidsCli = new Steroids
        debug: argv.debug
        argv: argv

      steroidsCli.execute()

  Help: Help
  paths: paths
