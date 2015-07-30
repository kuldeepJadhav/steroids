fs = require 'fs'

module.exports = readJsonConfigFrom = (path) ->
  try
    content = fs.readFileSync path
    JSON.parse content
  catch e
    throw new Error "Could not parse JSON configuration from '#{path}'"
