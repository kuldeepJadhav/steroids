log = require "../log"

module.exports = runModuleCommand = (cmd, argv) ->
  Promise.resolve()
    .then(->
      switch cmd
        when "create"
          runModuleCreate = require('./create')

          Promise.resolve(argv)
            .then(parseCreateArgs)
            .then(runModuleCreate)

        when "deploy"
          runModuleDeploy = require('./deploy')

          runModuleDeploy()

        when "init"
          runModuleInit = require('./init')

          Promise.resolve(argv)
            .then(parseInitArgs)
            .then(runModuleInit)

        when "refresh"
          runModuleRefresh = require('./refresh')

          Promise.resolve(argv)
            .then(parseRefreshArgs)
            .then(runModuleRefresh)

        else
          Usage = require "../usage"
          usage = new Usage
          usage.module()
    )
    .catch(handleKnownErrorStates)

parseCreateArgs = (argv) ->
  [section, command, moduleName] = argv._
  repoUrl = argv['repo-url']

  { moduleName, repoUrl }

parseInitArgs = (argv) ->
  {
    appId: argv['app-id']
    apiKey: argv['api-key']
    userId: argv['user-id']
    authToken: argv['auth-token']
  }

parseRefreshArgs = (argv) ->
  argv['app-id']

handleKnownErrorStates = (error) ->
  if (error.message.match /Please run again with/) or (error.message.match /endpoint requires authentication/)
    log.error error.message
  else if error.message.match /Cannot find module/
    log.error "Please run `steroids module init` first."
  else if error.message.match /Did not recognize command/
    log.error error.message
    console.log "Please see `steroids help` for available commands."
  else
    throw error

  process.exit(-1)
