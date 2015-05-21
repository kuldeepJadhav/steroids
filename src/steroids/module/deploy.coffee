fs = require 'fs'

paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = deployModule = (argv) ->
  readDeploymentDescription()
    .then(
      (module) -> updateModule module
      (error) -> createModule()
    )
    .then(writeDeploymentDescription)

createModule = ->
  http.requestAuthenticated(
    "POST",
    RuntimeConfig.endpoints.getModuleCreateUrl()
  )

updateModule = ->
  throw new Error "Not implemented"

deploymentDescriptionPath = paths.application.configs.module.deployment

readDeploymentDescription = ->
  new Promise (resolve) ->
    resolve JSON.parse fs.readFileSync deploymentDescriptionPath

writeDeploymentDescription = writeJsonStringTo deploymentDescriptionPath
