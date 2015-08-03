fs = require 'fs'
path = require 'path'

Download = require 'download'
Promise = require 'bluebird'

log = require "../../log"
paths = require "../../paths"

moduleApi = require '../moduleApi'
writeJsonStringTo = require '../writeJsonStringTo'
readJsonConfigFrom = require '../readJsonConfigFrom'

MODULE_DIR = paths.application.composerModulesDir
MODULE_PACKAGE_PATH = paths.application.configs.module.package

module.exports = installModule = (args) ->
  unless args.moduleName
    throw new Error """
      Module name required.

      Please run again with the target module name as an argument.
    """

  moduleApi.repository
    .findByName(args.moduleName)
    .then(getLatestVersion)
    .catch((e) ->
      throw new Error """
        Module '#{args.moduleName}' is not published in the repository.
      """
    )
    .tap (module) ->
      console.log "About to install #{args.moduleName}..."
    .then (latestVersion) ->
      installationTargetDir = getModuleInstallationTargetDir args.moduleName
      sourceZip = latestVersion.source

      installModule(installationTargetDir, sourceZip).then ->
        readModulePackageDescription()
          .catch(-> { dependencies: {} })
          .then(addModuleDependency args.moduleName, latestVersion)
          .then(writeModulePackageDescription)
    .then ->
      log.ok "Module installation complete."

getLatestVersion = (module) ->
  [ latestVersion ] = module.versions

  if !latestVersion.published
    throw new Error "No published version of module available"

  latestVersion

installModule = (destination, moduleZipUrl) ->
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

addModuleDependency = (moduleName, installedVersion) -> (pkg) ->
  pkg.dependencies[moduleName] = installedVersion
  pkg

readModulePackageDescription = ->
  new Promise (resolve) ->
    resolve readJsonConfigFrom MODULE_PACKAGE_PATH

writeModulePackageDescription = writeJsonStringTo MODULE_PACKAGE_PATH

