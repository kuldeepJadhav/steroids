fs = require 'fs'

paths = require '../paths'
refreshModule = require './refresh'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = initModule = (argv) ->
  Promise.resolve(argv)
    .then(parseInitArgs)
    .then(stringifyPrettyJson)
    .then(writeJsonStringTo paths.application.configs.module.env)
    .then(refreshModule)

parseInitArgs = (argv) ->
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

stringifyPrettyJson = (json) ->
  JSON.stringify(
    dataToEncode = json
    recursiveWalkerThingy = null
    indentBy = 2
  )
