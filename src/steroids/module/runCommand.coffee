paths = require('../paths')
fs = require('fs')

module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "init"
      Promise.resolve(argv)
        .then(parseArgs)
        .then(writeConfig)

parseArgs = (argv) ->
  opts = {
    appId: argv['app-id']
    userId: argv['user-id']
    apiKey: argv['api-key']
  }

  unless opts.appId? && opts.userId? && opts.apiKey?
    throw new Error "One of app-id, user-id or api-key is not defined. Please run again with --api-key=abc, --user-id=1 and --app-id=2."

  opts

stringifyPrettyJson = (json) ->
  JSON.stringify(
    dataToEncode = json
    recursiveWalkerThingy = null
    indentBy = 2
  )

writePrettyJson = (filename, json) ->
  fs.writeFileSync filename, stringifyPrettyJson(json)

writeConfig = (json) ->
  writePrettyJson paths.application.configs.env, json
