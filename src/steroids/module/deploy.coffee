paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = deployModule = (argv) ->
  Promise.resolve()
    .then(createModule)
    .then(writeJsonStringTo paths.application.configs.module)

createModule = ->
  http.requestAuthenticated(
    "POST",
    RuntimeConfig.endpoints.getModuleCreateUrl()
  )
