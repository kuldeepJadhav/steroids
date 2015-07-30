fs = require 'fs'

paths = require '../../paths'
Help = require '../../Help'

writeJsonStringTo = require '../writeJsonStringTo'

refreshModule = require './refresh'

module.exports = initModule = (options) ->

  unless options.appId? && options.authToken? && options.apiKey? && options.userId?
    throw new Error """
      One of app-id, api-key, user-id or auth-token is not defined.
      Please run again with --app-id=2 --api-key=abc --user-id=123 --auth-token=1
    """

  Promise.resolve(options)
    .then(writeJsonStringTo paths.application.configs.module.env)
    .then(refreshModule)
    .then ->
      Help.SUCCESS()
      steroidsCli.log """
        Module Development Harness connected to Composer 2 application!

        NEXT:
        =====

        - Start development by connecting with Steroids:
          Run `cd mobile && steroids connect`
        - If your Composer 2 application configuration changes:
          Run `steroids module refresh`
      """
