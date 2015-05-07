fs = require 'fs'

paths = require '../paths'
http = require '../httpRequest'

RuntimeConfig = require '../RuntimeConfig'

module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "init"
      commands.init(argv)

    when "refresh"
      commands.refresh()


commands = {
  init: (argv) ->
    Promise.resolve(argv)
      .then(parseArgs)
      .then(stringifyPrettyJson)
      .then(writeJsonStringTo paths.application.configs.env)
      .then(commands.refresh)

  refresh: ->
    getAppId()
      .then(retrieveEnvironment)
      .then(writeJsonStringTo paths.application.configs.module)
}


parseArgs = (argv) ->
  opts = {
    appId: argv['app-id']
    authToken: argv['auth-token']
    apiKey: argv['api-key']
  }

  unless opts.appId? && opts.authToken? && opts.apiKey?
    throw new Error "One of app-id, auth-token or api-key is not defined. Please run again with --api-key=abc, --auth-token=1 and --app-id=2."

  opts

getAppId = ->
  new Promise (resolve, reject) ->
    config = require paths.application.configs.env

    resolve config.appId

stringifyPrettyJson = (json) ->
  JSON.stringify(
    dataToEncode = json
    recursiveWalkerThingy = null
    indentBy = 2
  )

writeJsonStringTo = (filename) -> (json) ->
  fs.writeFileSync filename, json

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    "GET"
    RuntimeConfig.endpoints.getEnvApiUrl(id)
  )
