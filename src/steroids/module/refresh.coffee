
paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = refreshModule = ->
  Promise.resolve()
    .then(getAppId)
    .then(retrieveEnvironment)
    .then(writeJsonStringTo paths.application.configs.appgyver)

getAppId = ->
  if argv['app-id']
    argv['app-id']
  else
    config = require paths.application.configs.env
    config.appId

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    "GET"
    RuntimeConfig.endpoints.getEnvApiUrl(id)
  )
