fs = require 'fs'

module.exports = writeJsonStringTo = (filename) -> (json) ->
  fs.writeFileSync filename, json
