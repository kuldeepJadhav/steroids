fs = require 'fs'
chalk = require 'chalk'
paths = require '../paths'

module.exports = writeJsonStringTo = (filepath) -> (json) ->
  fs.writeFileSync filepath, json
  wroteFile filepath

wroteFile = (filepath) ->
  filename = filepath.replace paths.applicationDir, '.'
  console.log "#{chalk.bold.green '>'} Wrote #{filename}"
