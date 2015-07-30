chalk = require 'chalk'
fs = require 'fs'
path = require 'path'

Help = require '../../Help'
paths = require '../../paths'

runSbawn = require '../runSbawn'

module.exports = createModuleProject = ({ moduleName, repoUrl }) ->
  unless moduleName?
    throw new Error """
      Module name not defined. Please run again with the module name as an argument.
    """
  repoUrl ?= ""

  steroidsCli.debug "Creating a new Composer 2 Module in #{chalk.bold fullPath}..."

  fullPath = getWritableModulePath moduleName

  runSbawn(
    path.join paths.scriptsDir, "createModuleProject.sh"
    [moduleName, repoUrl]
  ).then (session) ->
    if session.stdout.match(/npm ERR!/)
      throw new Error "npm install could not be completed"
    else
      Help.SUCCESS()
      steroidsCli.log """
        Module Development Harness created!

        NEXT:
        =====

        1. Run `cd #{moduleName}`
        2. Retrieve and run a module initialization command from Composer 2:
           https://composer2.appgyver.com/modules/connect
        3. Run `cd mobile && steroids connect`

        Good luck!
      """

getWritableModulePath = (moduleName) ->
  fullPath = path.join process.cwd(), moduleName

  if fs.existsSync fullPath
    Help.error()
    steroidsCli.log "Directory #{chalk.bold(moduleName)} already exists. Remove it to continue."
    process.exit(1)

  fullPath
