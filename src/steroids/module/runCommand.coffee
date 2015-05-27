
module.exports = runModuleCommand = (cmd, argv) ->
  Promise.resolve().then ->
    switch cmd
      when "create"
        require('./create')(argv)

      when "deploy"
        require('./deploy')(argv)

      when "init"
        require('./init')(argv)

      when "refresh"
        require('./refresh')(argv)

      else
        Usage = require "../usage"
        usage = new Usage
        usage.module()
