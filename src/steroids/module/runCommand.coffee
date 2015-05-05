fs = require 'fs'

paths = require '../paths'
http = require '../httpRequest'

RuntimeConfig = require '../RuntimeConfig'

module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "init"
      Promise.resolve(argv)
        .then(parseArgs)
        .then(stringifyPrettyJson)
        .then(writeJsonStringTo paths.application.configs.env)

    when "refresh"
      getAppId()
        .then(retrieveEnvironment)
        .then(writeJsonStringTo paths.application.configs.module)

parseArgs = (argv) ->
  opts = {
    appId: argv['app-id']
    userId: argv['user-id']
    apiKey: argv['api-key']
  }

  unless opts.appId? && opts.userId? && opts.apiKey?
    throw new Error "One of app-id, user-id or api-key is not defined. Please run again with --api-key=abc, --user-id=1 and --app-id=2."

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
