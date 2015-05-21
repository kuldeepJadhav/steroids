fs = require 'fs'
path = require 'path'

paths = require '../paths'
http = require '../httpRequest'
RuntimeConfig = require '../RuntimeConfig'
PackagerBase = require '../packager/Base'
Grunt = require '../Grunt'

writeJsonStringTo = require './writeJsonStringTo'

module.exports = deployModule = (argv) ->
  readDeploymentDescription()
    .catch((error) -> createModule())
    .then (module) ->
      nextVersion = getNextModuleVersion module
      createModuleVersion(module.id, nextVersion)
        .then(pushToModuleVersion module.id)
        .then(->
          findModule module.id
        )
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

getNextModuleVersion = (module) ->
  Number(module?.versions?[0]?.version || 0) + 1

pushToModuleVersion = (moduleId) -> (moduleVersion) ->
  packageModuleToDist()
    .then(zipModuleDist)
    .then(uploadWithInstructions moduleVersion.module_zip_upload_instructions)
    .then ->
      announceUploadCompleted moduleId, moduleVersion.id

packageModuleToDist = ->
  gruntTask = steroidsCli.options.argv["gruntTask"] || "default"
  new Grunt()
    .run(tasks: [gruntTask])
    .then ->
      paths.application.distDir

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
