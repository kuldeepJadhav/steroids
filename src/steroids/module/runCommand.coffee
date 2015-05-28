
module.exports = runModuleCommand = (cmd, argv) ->
  Promise.resolve().then ->
    switch cmd
      when "create"
        createModuleProject = require('./create')

        Promise.resolve(argv)
          .then(parseCreateArgs)
          .then(createModuleProject)

      when "deploy"
        require('./deploy')(argv)

      when "init"
        require('./init')(argv)

      when "refresh"
        require('./refresh')(argv)

      else
        throw new Error """
          Did not recognize command: #{cmd}
        """

parseCreateArgs = (argv) ->
  [section, command, moduleName] = argv._
  repoUrl = argv['repo-url']

  { moduleName, repoUrl }
