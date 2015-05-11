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
    Promise.resolve(argv)
      .then(getAppId)
      .then(retrieveEnvironment)
      .then(writeJsonStringTo paths.application.configs.module)
}


parseArgs = (argv) ->
  opts = {
    appId: argv['app-id']
    apiKey: argv['api-key']
    userId: argv['user-id']
    authToken: argv['auth-token']
  }

  unless opts.appId? && opts.authToken? && opts.apiKey? && opts.userId?
    throw new Error """
      One of app-id, api-key, user-id or auth-token is not defined.
      Please run again with --app-id=2 --api-key=abc --user-id=123 --auth-token=1
    """

  opts

getAppId = (argv) ->
  if argv['app-id']
    argv['app-id']
  else
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

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    "GET"
    RuntimeConfig.endpoints.getEnvApiUrl(id)
  )
