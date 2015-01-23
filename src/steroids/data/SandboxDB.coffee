util = require "util"
fs = require "fs"

request = require "request"
yaml = require 'js-yaml'

paths = require "../paths"
Login = require "../Login"
dataHelpers = require "./Helpers"

sandboxDBBaseURL = 'https://datastorage-api.appgyver.com'
sandboxDBURL = "#{sandboxDBBaseURL}/v1/datastorage"

class SandboxDB
  @SandboxDBError: class SandboxDBError extends steroidsCli.SteroidsError
  @ProvisionError: class ProvisionError extends SandboxDBError
  @WriteFileError: class WriteFileError extends SandboxDBError
  @ConnectionError: class ConnectionError extends SandboxDBError

  providerName: "AppGyver Sandbox Database"
  providerTypeId: 6

  constructor: (@options={}) ->
    @apiClient = request.defaults
      auth:
        user: Login.currentAccessToken()
        password: "X"

  get: =>
    return new Promise (resolve, reject) =>
      steroidsCli.debug "SANDBOXDB", "Initializing Sandbox DB"

      @readFromFile().then =>
        if @existsSync() #TODO: cannot be called before @readFromFile is resolved
          steroidsCli.debug "SANDBOXDB", "Sandbox DB already created"
          resolve()
        else
          steroidsCli.debug "SANDBOXDB", "Sandbox DB not created, creating a new one."
          @create().then resolve

  create: =>
    return new Promise (resolve, reject) =>
      steroidsCli.debug "SANDBOXDB", "Creating Sandbox DB"

      @provision()
      .then(@writeToFile)
      .then(resolve)

  provision: =>
    return new Promise (resolve, reject) =>
      steroidsCli.debug "SANDBOXDB", "Provisioning Sandbox DB"

      data =
        appId: dataHelpers.getAppId()

      steroidsCli.debug "SANDBOXDB", "POSTing data: #{JSON.stringify(data)} to path: /v1/credentials/provision"
      @apiClient
        method: "post"
        json: { data: data }
        url: "#{sandboxDBBaseURL}/v1/credentials/provision"
      , (err, res, body) =>
        if err?
          reject new ConnectionError "Could not connect to Sandbox DB"
        else if res.statusCode == 200 and body.code == 201 # The fuq?
          steroidsCli.debug "SANDBOXDB", "Provisioned Sandbox DB"
          @fromApiSchemaDict(body.body)
          resolve()
        else
          steroidsCli.debug "SANDBOXDB", "Provisioning Sandbox DB returned failure: #{body}"
          reject new ProvisionError

  writeToFile: =>
    return new Promise (resolve, reject) =>
      steroidsCli.debug "SANDBOXDB", "Writing configuration to file #{paths.application.configs.data.sandboxdb}"
      steroidsCli.debug "SANDBOXDB", "Writing configuration: #{JSON.stringify(@toConfigurationDict())}"

      dataHelpers.overwriteYamlConfig(paths.application.configs.data.sandboxdb, @toConfigurationDict())
      .then =>
        steroidsCli.debug "SANDBOXDB", "Writing configuration to file #{paths.application.configs.data.sandboxdb} was success"
        resolve()
      .catch (err)=>
        steroidsCli.debug "SANDBOXDB", "Writing configuration to file #{paths.application.configs.data.sandboxdb} was failure", err
        reject new WriteFileError err

  readFromFile: =>
    return new Promise (resolve, reject) =>
      steroidsCli.debug "SANDBOXDB", "Reading configuration from file #{paths.application.configs.data.sandboxdb}"

      unless fs.existsSync(paths.application.configs.data.sandboxdb)
        steroidsCli.debug "SANDBOXDB", "Configuration file #{paths.application.configs.data.sandboxdb} was missing"
        resolve()
        return

      @fromConfigurationDict yaml.safeLoad(fs.readFileSync(paths.application.configs.data.sandboxdb, 'utf8'))

      resolve()

  configurationKeysForProxy: =>
    bucket_id: @id
    steroids_api_key: @apikey
    bucket_name: @name

  # legacy yaml format abstracted here
  toConfigurationDict: =>
    apikey: @apikey
    bucket: @name
    bucket_id: @id

  # legacy yaml format abstracted here
  fromConfigurationDict: (obj)=>
    @apikey = obj.apikey
    @name = obj.bucket
    @id = obj.bucket_id

  # datastore api schema abstracted here
  fromApiSchemaDict: (obj)=>
    @apikey = "#{obj.login}#{obj.password}"
    @name = obj.name
    @id = obj.datastore_bucket_id

  existsSync: -> #TODO: make async
    return @id?

module.exports = SandboxDB
