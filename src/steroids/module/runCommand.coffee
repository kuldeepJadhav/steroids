fs = require 'fs'
path = require 'path'

paths = require '../paths'
http = require '../httpRequest'
sbawn = require '../sbawn'

RuntimeConfig = require '../RuntimeConfig'

module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "create"
      commands.create(argv)

    when "init"
      commands.init(argv)

    when "refresh"
      commands.refresh()


commands = {
  create: (argv) ->
    Promise.resolve(argv)
      .then(parseCreateArgs)
      .then(createModuleProject)

  init: (argv) ->
    Promise.resolve(argv)
      .then(parseInitArgs)
      .then(stringifyPrettyJson)
      .then(writeJsonStringTo paths.application.configs.env)
      .then(commands.refresh)

  refresh: ->
    Promise.resolve(argv)
      .then(getAppId)
      .then(retrieveEnvironment)
      .then(writeJsonStringTo paths.application.configs.module)
}


parseCreateArgs = (argv) ->
  [section, command, moduleName] = argv._
  repoUrl = argv['repo-url'] || ""

  unless moduleName?
    throw new Error """
      Module name not defined. Please run again with the module name as an argument.
    """

  { moduleName, repoUrl }

createModuleProject = ({ moduleName, repoUrl }) ->
  new Promise (resolve, reject) ->
    session = sbawn
      cmd: path.join paths.scriptsDir, "createModuleProject.sh"
      args: [moduleName, repoUrl]
      stdout: true
      stderr: true

    session.on 'exit', ->
      if session.code != 0 || session.stdout.match(/npm ERR!/)
        reject new Error "Something went wrong!"

      resolve()



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
