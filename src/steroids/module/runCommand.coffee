
module.exports = runModuleCommand = (cmd, argv) ->
  Promise.resolve().then ->
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
        throw new Error """
          Did not recognize command: #{cmd}
        """

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
