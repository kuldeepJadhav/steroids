RuntimeConfig = require '../RuntimeConfig'

module.exports = moduleUrls =
  module:
    find: (moduleId) ->
      "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}"

    create: RuntimeConfig.endpoints.getModuleApiUrl

    version:
      create: (moduleId) ->
        "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}/versions"

      update: (moduleId, moduleVersionId) ->
        "#{RuntimeConfig.endpoints.getModuleApiUrl()}/#{moduleId}/versions/#{moduleVersionId}"
