fs = require 'fs'
path = require 'path'

paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
PackagerBase = require '../packager/Base'

writeJsonStringTo = require './writeJsonStringTo'

module.exports = deployModule = (argv) ->
  readDeploymentDescription()
    .then(
      (deployedModule) ->
        nextVersion = getNextModuleVersion deployedModule
        createModuleVersion(deployedModule.id, nextVersion)
          .then(pushToModuleVersion deployedModule.id)
          .then ->
            deployedModule.id
      (error) ->
        createModule().then (module) ->
          createModuleVersion(module.id, 1)
            .then(pushToModuleVersion module.id)
            .then ->
              module.id
    )
    .then(findModule)
    .then(writeDeploymentDescription)

createModule = ->
  http.requestAuthenticated(
    method: "POST"
    url: getModuleCreateUrl()
    json: true
  )
  .then (data) ->
    data.module

createModuleVersion = (moduleId, versionIdentifier) ->
  http.requestAuthenticated(
    method: "POST"
    url: getModuleVersionCreateUrl(moduleId)
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
    url: getModuleUrl(moduleId)
    json: true
  )
  .then (data) ->
    data.module

getNextModuleVersion = (deployedModule) ->
  Number(deployedModule?.versions?[0]?.version) + 1

pushToModuleVersion = (moduleId) -> (moduleVersion) ->
  zipModuleDist(paths.application.distDir)
    .then(uploadWithInstructions moduleVersion.module_zip_upload_instructions)
    .then ->
      announceUploadCompleted moduleId, moduleVersion.id

zipModuleDist = (distDir) ->
  new PackagerBase({ distDir })
    .create()
    .then ->
      paths.temporaryZip

uploadWithInstructions = (uploadInstructions) -> (moduleZipPath) ->
  http.request(
    method: "POST"
    url: uploadInstructions.__endpoint
    formData:
      key: uploadInstructions.key
      AWSAccessKeyId: uploadInstructions.AWSAccessKeyId
      acl: uploadInstructions.acl
      policy: uploadInstructions.policy
      signature: uploadInstructions.signature
      success_action_status: uploadInstructions.success_action_status
      utf8: uploadInstructions.utf8
      file: fs.createReadStream moduleZipPath
  )

announceUploadCompleted = (moduleId, moduleVersionId) ->
  http.requestAuthenticated(
    method: "PUT"
    url: getModuleVersionUpdateUrl(moduleId, moduleVersionId)
    json: true
    body:
      version:
        module_zip_last_uploaded_at: (new Date).toISOString()
  )

deploymentDescriptionPath = paths.application.configs.module.deployment

readDeploymentDescription = ->
  new Promise (resolve) ->
    resolve JSON.parse fs.readFileSync deploymentDescriptionPath

writeDeploymentDescription = writeJsonStringTo deploymentDescriptionPath


getModuleCreateUrl = RuntimeConfig.endpoints.getModuleApiUrl

getModuleVersionCreateUrl = (moduleId) ->
  "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}/versions"

getModuleUrl = (moduleId) ->
  "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}"

getModuleVersionUpdateUrl = (moduleId, moduleVersionId) ->
  "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}/versions/#{moduleVersionId}"
