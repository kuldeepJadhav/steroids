http = require '../httpRequest'

urls = require './urls'

module.exports = moduleApi =
  repository:
    findByName: (moduleName) ->
      http.requestAuthenticated(
        method: "GET"
        url: urls.repository.find(moduleName)
        json: true
      )
      .then (data) ->
        data.module
