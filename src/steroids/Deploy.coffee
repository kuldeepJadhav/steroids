fs = require "fs"

request = require "request"
restler = require "restler"

paths = require "./paths"
Login = require "./Login"
CloudConfig = require "./CloudConfig"
DeployConverter = require "./DeployConverter"

class Deploy

  @DeployError: class DeployError extends steroidsCli.SteroidsError

  constructor: (@options={}) ->
    @converter = new DeployConverter
    @cloudConfig = JSON.parse(fs.readFileSync(paths.application.configs.cloud, "utf8")) if fs.existsSync paths.application.configs.cloud
    @cloudUrl = steroidsCli.options.argv.cloudUrl || "https://cloud.appgyver.com"

  run: =>
    Updater = require "./Updater"
    updater = new Updater
    updater.check
      from: "deploy"

    new Promise (resolve, reject) =>
      if steroidsCli.projectType is "cordova" and !@cloudConfig
        if @options.allowConfigCreation
          fse = require "fs-extra"
          fse.ensureDirSync paths.application.configDir
        else
          reject new DeployError "To deploy your app to the cloud, you need to allow Steroids CLI to create a config directory to store the app ID and a secure hash. Please run \n\n  steroids deploy --allowConfigCreation\n\nin your project directory to proceed. The config file will be created at config/cloud.json."
          return

      ProjectFactory = require "./project/ProjectFactory"
      project = ProjectFactory.create()

      project.push().then =>
        @deploy()
      .then =>
        resolve()
      .catch (error) =>
        reject error

  deploy: =>
    new Promise (resolve, reject) =>
      steroidsCli.log "Uploading application to AppGyver Cloud."
      @uploadApplicationJSON()
        .then(@uploadApplicationZip)
        .then(@updateConfigurationFile)
        .then ->
          resolve()
        .catch (error) ->
          reject error

  uploadApplicationJSON: =>
    new Promise (resolve, reject) =>
      @app = @converter.applicationCloudSchemaRepresentation()

      if @cloudConfig?.id?
        @app.id = @cloudConfig.id
        steroidsCli.debug "DEPLOY", "Updating existing app with id #{@app.id}"
        method = "put"
        endpoint = "/studio_api/applications/#{@app.id}"
      else
        steroidsCli.debug "DEPLOY", "Uploading a new app"
        method = "post"
        endpoint = "/studio_api/applications"

      requestData =
        application: @app

      @cloudUpload(method, endpoint, requestData).then (data) =>
        steroidsCli.debug "DEPLOY", "Got cloud upload response"
        @cloudApp = data
        resolve()
      .catch (error) ->
        Help = require "./Help"
        Help.error()
        reject error

  cloudUpload: (method, endpoint, json) =>
    new Promise (resolve, reject) =>
      request
        auth:
          user: Login.currentAccessToken()
          password: "X"
        method: method
        json: json
        url: "#{@cloudUrl}#{endpoint}"
      , (err, res, data) ->
        if err?
          reject new DeployError "Could not connect to cloud.appgyver.com"
        else if res.statusCode == 200 or res.statusCode == 201
          resolve(data)
        else
          reject new DeployError """
          Check that you have correct app id in config/cloud.json. Try removing the file and a new cloud.json file will be created.
          """

  uploadApplicationZip: =>
    new Promise (resolve, reject) =>
      sourcePath = paths.temporaryZip

      params =
        success_action_status: "201"
        utf8: ""
        key: @cloudApp.custom_code_zip_upload_key
        acl: @cloudApp.custom_code_zip_upload_acl
        policy: @cloudApp.custom_code_zip_upload_policy
        signature: @cloudApp.custom_code_zip_upload_signature
        AWSAccessKeyId: @cloudApp.custom_code_zip_upload_access_key
        file: restler.file(
          sourcePath, # source path
          "custom_code.zip", # filename
          fs.statSync(sourcePath).size, # file size
          "binary", # file encoding
          "application/octet-stream") # file content type

      uploadRequest = restler.post @cloudApp.custom_code_zip_upload_url, { multipart: true, data:params }

      uploadRequest.on "success", ->
        steroidsCli.debug "DEPLOY", "Updated application zip to S3"
        resolve()

      uploadRequest.on "error", (error)->
        reject new DeployError "Error uploading application code to cloud: #{error}"

  updateConfigurationFile: =>
    new Promise (resolve, reject) =>
      steroidsCli.debug "DEPLOY", "Updating #{paths.application.configs.cloud}"

      cloudConfig = new CloudConfig
        id: @cloudApp.id
        identification_hash: @cloudApp.identification_hash

      cloudConfig.saveSync()
      config = cloudConfig.getCurrentSync()

      shareBaseUrl = steroidsCli.options.argv.shareURL || "https://share.appgyver.com"
      shareUrl = "#{shareBaseUrl}/?id=#{config.id}&hash=#{config.identification_hash}"

      chalk = require "chalk"
      steroidsCli.log "\nShare URL: #{chalk.bold(shareUrl)}"

      if steroidsCli.options.argv.share
        open = require "open"
        open shareUrl

      resolve()

module.exports = Deploy
