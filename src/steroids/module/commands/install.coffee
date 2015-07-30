module.exports = installModule = (args) ->
  unless args.moduleName
    throw new Error """
      Module name required.

      Please run again with the target module name as an argument.
    """
