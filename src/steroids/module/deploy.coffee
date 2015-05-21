fs = require 'fs'

paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'

writeJsonStringTo = require './writeJsonStringTo'

module.exports = deployModule = (argv) ->
  readDeploymentDescription()
    .then(
      (deployedModule) ->
        createModuleVersion(
          deployedModule.id
          getNextModuleVersion deployedModule
        ).then ->
          findModule deployedModule.id
      (error) ->
        createModule().then (module) ->
          createModuleVersion(module.id, 1).then ->
            findModule module.id
    )
    .then(writeDeploymentDescription)

createModule = ->
  http.requestAuthenticated(
    method: "POST"
    url: RuntimeConfig.endpoints.getModuleCreateUrl()
    json: true
  )
  .then (data) ->
    data.module

createModuleVersion = (moduleId, versionIdentifier) ->
  http.requestAuthenticated(
    method: "POST"
    url: RuntimeConfig.endpoints.getModuleVersionCreateUrl(moduleId)
    json: true
    body:
      version:
        version: versionIdentifier
  )
  .then (data) ->
    data.version

findModule = (moduleId) ->
  http.requestAuthenticated(
    method: "GET"
    url: RuntimeConfig.endpoints.getModuleUrl(moduleId)
    json: true
  )
  .then (data) ->
    data.module

getNextModuleVersion = (deployedModule) ->
  Number(deployedModule?.versions?[0]?.version) + 1

deploymentDescriptionPath = paths.application.configs.module.deployment

readDeploymentDescription = ->
  new Promise (resolve) ->
    resolve JSON.parse fs.readFileSync deploymentDescriptionPath

writeDeploymentDescription = writeJsonStringTo deploymentDescriptionPath
