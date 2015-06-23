_ = require "lodash"
paths = require "../paths"
features = require '../features'
Help = require '../Help'

class SupersonicConfig

  defaults:
    copyToUserFiles: []
    hooks:
      preMake:
        cmd: null
        args: null
      postMake:
        cmd: null
        args: null
    splashscreen:
      autohide: true

  constructor: ->
    @appConfigPath = paths.application.configs.app
    @structureConfigPath = paths.application.configs.structure

    delete require.cache[@appConfigPath] if require.cache[@appConfigPath]
    delete require.cache[@structureConfigPath] if require.cache[@structureConfigPath]

  getCurrent: ->
    getConfigForPath = (path) ->
      try
        config = require path
      catch error
        Help.error()
        console.error "Could not parse #{path}. Please ensure it is valid CoffeeScript. \n\n#{error}"
        process.exit 1

      return config

    appConfig = getConfigForPath @appConfigPath
    structureConfig =
      structure: getConfigForPath @structureConfigPath

    @currentConfig = _.merge appConfig, structureConfig

    @setDefaults @currentConfig

    if features.project.forceDisableSplashScreenAutohide
      @currentConfig.splashscreen = autohide: false

    @currentConfig

  setDefaults: ->
    @currentConfig = _.merge @currentConfig, @defaults


module.exports = SupersonicConfig
