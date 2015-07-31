paths = require "./paths"

module.exports = class RuntimeConfig

  @endpoints:
    getEnvApiUrl: (id) ->
      envApiHost = paths.endpoints.envApiHost

      "#{envApiHost}/api/v1/applications/#{id}/environment"

    getModuleApiRoot: ->
      moduleApiHost = paths.endpoints.moduleApiHost

      "#{moduleApiHost}/api/v1"
