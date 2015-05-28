fs = require 'fs'

paths = require '../paths'
refreshModule = require './refresh'
writeJsonStringTo = require './writeJsonStringTo'

module.exports = initModule = (options) ->

  unless options.appId? && options.authToken? && options.apiKey? && options.userId?
    throw new Error """
      One of app-id, api-key, user-id or auth-token is not defined.
      Please run again with --app-id=2 --api-key=abc --user-id=123 --auth-token=1
    """

  Promise.resolve(options)
    .then(writeJsonStringTo paths.application.configs.module.env)
    .then(refreshModule)
