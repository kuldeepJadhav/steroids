fs = require 'fs'
chalk = require 'chalk'
path = require 'path'

paths = require '../paths'

module.exports = writeJsonStringTo = (filepath) -> (json) ->
  ensureParentDirectoryExists filepath
  fs.writeFileSync filepath, prettyJsonStringify json
  wroteFile filepath

ensureParentDirectoryExists = (filepath) ->
  parentDir = path.dirname filepath
  if !fs.existsSync parentDir
    throw new Error """
      Unable to write to #{beautifyProjectFilepath filepath}.
      Parent directory #{beautifyProjectFilepath parentDir} does not exist.
    """

prettyJsonStringify = (json) ->
  JSON.stringify(
    dataToEncode = json
    recursiveWalkerThingy = null
    indentBy = 2
  )

wroteFile = (filepath) ->
  filename = beautifyProjectFilepath filepath
  console.log "#{chalk.bold.green '>'} Wrote #{filename}"

beautifyProjectFilepath = (filepath) ->
  filepath.replace paths.applicationDir, '.'
