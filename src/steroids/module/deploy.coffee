fs = require 'fs'
path = require 'path'

paths = require '../paths'
http = require '../httpRequest'
Help = require '../Help'
log = require "../log"
PackagerBase = require '../packager/Base'
Grunt = require '../Grunt'

writeJsonStringTo = require './writeJsonStringTo'
readJsonConfigFrom = require './readJsonConfigFrom'
urls = require './urls'

module.exports = deployModule = ->
  console.log "About to deploy module..."

  readDeploymentDescription()
    .catch((error) -> createModule())
    .then((module) ->
      nextVersion = getNextModuleVersionNumber module
      createModuleVersion(module.id, nextVersion)
        .then(pushToModuleVersion module.id)
        .then(->
          findModule(module.id)
        )
    ).then (module) ->
      writeDeploymentDescription module

      Help.SUCCESS()
      steroidsCli.log """
        Deployed module at: #{getDeploymentLocation(module)}
      """

createModule = ->
  http.requestAuthenticated(
    method: "POST"
    url: urls.module.create()
    json: true
  )
  .then (data) ->
    data.module

createModuleVersion = (moduleId, versionIdentifier) ->
  http.requestAuthenticated(
    method: "POST"
    url: urls.module.version.create(moduleId)
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
    url: urls.module.find(moduleId)
    json: true
  )
  .then (data) ->
    data.module

getCurrentVersion = (module) ->
  module?.versions?[0]

getDeploymentLocation = (module) ->
  getCurrentVersion(module)?.location

getNextModuleVersionNumber = (module) ->
  Number(getCurrentVersion(module)?.version || 0) + 1

pushToModuleVersion = (moduleId) -> (moduleVersion) ->
  packageModuleToDist()
    .then(zipModuleDist)
    .then(uploadWithInstructions moduleVersion.module_zip_upload_instructions)
    .then ->
      announceUploadCompleted moduleId, moduleVersion.id

packageModuleToDist = ->
  console.log "About to run Grunt tasks..."

  gruntTask = steroidsCli.options.argv["gruntTask"] || "default"
  new Grunt()
    .run(tasks: [gruntTask])
    .then ->
      log.ok "Successfully compiled module"

      paths.application.distDir

zipModuleDist = (distDir) ->
  console.log "About to package module dist..."

  new PackagerBase({ distDir })
    .create()
    .then ->
      log.ok "Successfully packaged module"
      paths.temporaryZip

uploadWithInstructions = (uploadInstructions) -> (moduleZipPath) ->
  console.log "About to upload module package..."
  data =
    key: uploadInstructions.key
    AWSAccessKeyId: uploadInstructions.AWSAccessKeyId
    acl: uploadInstructions.acl
    policy: uploadInstructions.policy
    signature: uploadInstructions.signature
    success_action_status: uploadInstructions.success_action_status
    utf8: uploadInstructions.utf8

  if uploadInstructions.metadata?
    for key, value of uploadInstructions.metadata
      data[key] = value

  data.file = fs.createReadStream moduleZipPath

  http.request(
    method: "POST"
    url: uploadInstructions.__endpoint
    formData: data
  ).then ->
    log.ok "Successfully uploaded module package"

announceUploadCompleted = (moduleId, moduleVersionId) ->
  http.requestAuthenticated(
    method: "PUT"
    url: urls.module.version.update(moduleId, moduleVersionId)
    json: true
    body:
      version:
        module_zip_last_uploaded_at: (new Date).toISOString()
  )

deploymentDescriptionPath = paths.application.configs.module.deployment

readDeploymentDescription = ->
  new Promise (resolve) ->
    resolve readJsonConfigFrom deploymentDescriptionPath

writeDeploymentDescription = writeJsonStringTo deploymentDescriptionPath
