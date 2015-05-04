fs = require 'fs'

paths = require '../paths'
http = require '../httpRequest'

module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "init"
      Promise.resolve(argv)
        .then(parseArgs)
        .then(stringifyPrettyJson)
        .then(writeJsonStringTo paths.application.configs.env)

    when "refresh"
      Promise.resolve(argv)
        .then(retrieveEnvironment getAppId())
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
  config = require paths.application.configs.env
  config.appId

stringifyPrettyJson = (json) ->
  JSON.stringify(
    dataToEncode = json
    recursiveWalkerThingy = null
    indentBy = 2
  )

writeJsonStringTo = (filename) -> (json) ->
  fs.writeFileSync filename, json

retrieveEnvironment = (id) -> (argv) ->
  http.requestAuthenticated(
    "GET"
    "https://env-api.devgyver.com/api/v1/applications/#{id}/environment"
  )
