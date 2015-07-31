fs = require 'fs'

log = require "../../log"
paths = require "../../paths"

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
    .then (module) ->
      [ latestVersion ] = module.versions

      moduleZipUrl = latestVersion.source

      console.log "About to install #{module.namespace}..."

      ensureModuleDirectoryExists()

ensureModuleDirectoryExists = ->
  if !fs.existsSync paths.application.composerModulesDir
    fs.mkdirSync paths.application.composerModulesDir
