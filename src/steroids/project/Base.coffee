sbawn = require "../sbawn"
util = require "util"
paths = require "../paths"
chalk = require "chalk"
fs = require "fs"
path = require "path"
Help = require "../Help"
ApplicationConfigUpdater = require "../ApplicationConfigUpdater"
AppSettings = require "../AppSettings"
Grunt = require "../Grunt"
ConfigXmlGenerator = require "../ConfigXmlGenerator"
ConfigJsonGenerator = require "../ConfigJsonGenerator"

class MakeError extends steroidsCli.SteroidsError

module.exports = class ProjectBase


  constructor: (@options={}) ->
    @config = steroidsCli.config.getCurrent()

  initialize: (options={}) =>
    options.onSuccess()

  push: =>
    new Promise (resolve, reject) =>
      steroidsCli.debug "Starting push"

      @make()
      .then =>
        @package()
      .then =>
        resolve()

  preMake: (options = {}) =>
    if @config.hooks.preMake.cmd and @config.hooks.preMake.args

      util.log "preMake starting: #{@config.hooks.preMake.cmd} with #{@config.hooks.preMake.args}"

      preMakeSbawn = sbawn
        cmd: @config.hooks.preMake.cmd
        args: @config.hooks.preMake.args
        stdout: true
        stderr: true

      steroidsCli.debug "preMake spawned"

      preMakeSbawn.on "exit", =>
        errorCode = preMakeSbawn.code

        if errorCode == 137 and @config.hooks.preMake.cmd == "grunt"
          util.log "command was grunt build which exists with 137 when success, setting error code to 0"
          errorCode = 0

        util.log "preMake done"

        if errorCode == 0
          options.onSuccess.call() if options.onSuccess?
        else
          util.log "preMake resulted in error code: #{errorCode}"
          options.onFailure.call() if options.onFailure?

    else
      options.onSuccess.call() if options.onSuccess?


  postMake: (options = {}) =>
    if @config.hooks.postMake.cmd and @config.hooks.postMake.args

      util.log "postMake started"

      postMakeSbawn = sbawn
        cmd: @config.hooks.postMake.cmd
        args: @config.hooks.postMake.args
        stdout: true
        stderr: true

      postMakeSbawn.on "exit", =>
        util.log "postMake done"

        options.onSuccess.call() if options.onSuccess?
    else
      options.onSuccess.call() if options.onSuccess?

  makeOnly: (options = {}) => # without hooks
    if options.cordova
      steroidsCli.debug "Running Grunt tasks for Cordova project..."

      @copyCordovaFiles()

      options.onSuccess?.call()
    else
      applicationConfigUpdater = new ApplicationConfigUpdater

      applicationConfigUpdater.ensureNodeModulesDir().then( =>

        steroidsCli.debug "Running Grunt tasks..."

        grunt = new Grunt()
        grunt.run {tasks: [steroidsCli.options.argv["gruntTask"] || "default"]}, =>
          unless steroidsCli.options.argv.noSettingsJson == true
            @createSettingsJson()
          @createConfigXml()
          @createConfigJson()
          options.onSuccess.call() if options.onSuccess?

      ).catch (errorMessage)->
        Help.error()
        console.log errorMessage
        process.exit(1)

  make: (options = {}) => # with pre- and post-make hooks

    steroidsCli.debug "Making with hooks."

    new Promise (resolve, reject) =>

      try
        @config = steroidsCli.config.getCurrent()
      catch e
        reject new MakeError "Could not get project configuration. Is everything set up right in the config/ folder?"

      @preMake
        onFailure: reject
        onSuccess: =>
          @makeOnly
            onFailure: reject
            onSuccess: =>
              @postMake options
              resolve()

  package: (options = {}) =>
    steroidsCli.debug "Packaging project..."

    PackagerFactory = require "../packager/PackagerFactory"
    packager = PackagerFactory.create()

    packager.create()
    .then( ->
      options.onSuccess() if options.onSuccess
    ).catch ->
      options.onFailure() if options.onFailure

  createSettingsJson: ->
    appSettings = new AppSettings()
    steroidsCli.debug "Creating #{path.relative paths.applicationDir, paths.application.dist.appgyverSettings} ..."
    appSettings.createJSONFile()

  createConfigXml: ->
    configXmlGenerator = new ConfigXmlGenerator()
    steroidsCli.debug "Creating #{path.relative paths.applicationDir, paths.application.dist.configIosXml} ..."
    configXmlGenerator.writeConfigIosXml()
    steroidsCli.debug "Creating #{path.relative paths.applicationDir, paths.application.dist.configAndroidXml} ..."
    configXmlGenerator.writeConfigAndroidXml()

  createConfigJson: ->
    configJsonGenerator = new ConfigJsonGenerator()
    steroidsCli.debug "Creating #{path.relative paths.applicationDir, paths.application.dist.configJson} ..."
    configJsonGenerator.writeConfigJson()
