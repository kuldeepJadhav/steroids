paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
writeJsonStringTo = require './writeJsonStringTo'
readJsonConfigFrom = require './readJsonConfigFrom'

module.exports = refreshModule = (appId = null) ->
  appId ?= readAppId()

  Promise.resolve(appId)
    .then(retrieveEnvironment)
    .then(writeJsonStringTo paths.application.configs.module.appgyver)

readAppId = ->
  readJsonConfigFrom(paths.application.configs.module.env).appId

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    method: "GET"
    url: RuntimeConfig.endpoints.getEnvApiUrl(id)
    json: true
  )
