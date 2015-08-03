fs = require 'fs'
path = require 'path'

Download = require 'download'
Promise = require 'bluebird'

log = require "../../log"
paths = require "../../paths"

moduleApi = require '../moduleApi'

MODULE_DIR = paths.application.composerModulesDir

module.exports = installModule = (args) ->
  unless args.moduleName
    throw new Error """
      Module name required.

      Please run again with the target module name as an argument.
    """

  moduleApi.repository
    .findByName(args.moduleName)
    .then(getLatestVersionZipUrl)
    .catch((e) ->
      throw new Error """
        Module '#{args.moduleName}' is not published in the repository.
      """
    )
    .tap (module) ->
      console.log "About to install #{args.moduleName}..."
    .then(installModule getModuleInstallationTargetDir args.moduleName)
    .then ->
      log.ok "Module installation complete."

getLatestVersionZipUrl = (module) ->
  [ latestVersion ] = module.versions

  if !latestVersion.published
    throw new Error "No published version of module available"

  moduleZipUrl = latestVersion.source

  moduleZipUrl

installModule = (destination) -> (moduleZipUrl) ->
  new Promise (resolve, reject) ->
    ensureModuleDirectoryExists()

    new Download(extract: true)
      .get(moduleZipUrl)
      .dest(destination)
      .run (err, files) ->
        return reject err if err?
        resolve files

ensureModuleDirectoryExists = ->
  if !fs.existsSync MODULE_DIR
    fs.mkdirSync MODULE_DIR

getModuleInstallationTargetDir = (moduleName) ->
  path.join MODULE_DIR, moduleName
