
module.exports = runModuleCommand = (cmd, argv) ->
  Promise.resolve().then ->
    switch cmd
      when "create"
        require('./create')(argv)

      when "init"
        require('./init')(argv)

      when "refresh"
        require('./refresh')(argv)

      else
        throw new Error """
          Did not recognize command: #{cmd}
        """
