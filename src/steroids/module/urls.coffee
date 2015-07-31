RuntimeConfig = require '../RuntimeConfig'

MODULE_API_ROOT = RuntimeConfig.endpoints.getModuleApiRoot()

module.exports = moduleUrls =
  repository:
    find: (moduleName) ->
      "#{MODULE_API_ROOT}/repository/#{moduleName}"

  module:
    find: (moduleId) ->
      "#{MODULE_API_ROOT}/modules/#{moduleId}"

    create: ->
      "#{MODULE_API_ROOT}/modules"

    version:
      create: (moduleId) ->
        "#{MODULE_API_ROOT}/modules/#{moduleId}/versions"

      update: (moduleId, moduleVersionId) ->
        "#{MODULE_API_ROOT}/modules/#{moduleId}/versions/#{moduleVersionId}"
