moduleApi = require '../moduleApi'

module.exports = installModule = (args) ->
  unless args.moduleName
    throw new Error """
      Module name required.

      Please run again with the target module name as an argument.
    """

  moduleApi.repository.findByName(args.moduleName)
    .catch((e) ->
      throw new Error """
        Module '#{args.moduleName}' is not published in the repository.
      """
    )
