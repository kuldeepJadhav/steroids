paths = require "./paths"

module.exports = class RuntimeConfig

  @endpoints:
    getEnvApiUrl: (id) ->
      envApiHost = paths.endpoints.envApiHost

      "#{envApiHost}/api/v1/applications/#{id}/environment"

    getModuleCreateUrl: ->
      moduleApiHost = paths.endpoints.moduleApiHost

      "#{moduleApiHost}/api/v1/modules"

    getModuleVersionCreateUrl: (moduleId) ->
      moduleApiHost = paths.endpoints.moduleApiHost

      "#{moduleApiHost}/api/v1/modules/#{moduleId}/versions"

    getModuleUrl: (moduleId) ->
      moduleApiHost = paths.endpoints.moduleApiHost

      "#{moduleApiHost}/api/v1/modules/#{moduleId}"
