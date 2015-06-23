
paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = refreshModule = (appId = null) ->
  appId ?= readAppId()

  Promise.resolve(appId)
    .then(retrieveEnvironment)
    .then(writeJsonStringTo paths.application.configs.module.appgyver)

readAppId = ->
  config = require paths.application.configs.module.env
  config.appId

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    method: "GET"
    url: RuntimeConfig.endpoints.getEnvApiUrl(id)
    json: true
  )
