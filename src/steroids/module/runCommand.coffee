
module.exports = runModuleCommand = (cmd, argv) ->
  switch cmd
    when "create"
      require('./create')(argv)

    when "init"
      require('./init')(argv)

    when "refresh"
      require('./refresh')(argv)
