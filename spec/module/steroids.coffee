path = require "path"
fs = require 'fs'

TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"

module.exports = steroids = ->
  testHelper = new TestHelper
  testHelper.prepare()

  run = (args...) ->
    testHelper.runInProject {
      # Passing undefined elements will cause runner to fail silently
      args: args.filter((a) -> a?)
    }

  checkable = (runner) ->
    check: (runnerAssertions) ->
      waitsFor ->
        runner.done

      runs ->
        runnerAssertions? runner

  pathToAppFile = (parts) ->
    path.join(testHelper.testAppPath, parts...)

  return new class SteroidsModuleCommandRunner

    file: (parts...) ->
      filepath = pathToAppFile parts

      readJson: -> JSON.parse fs.readFileSync filepath
      exists: -> fs.existsSync filepath
      clean: ->
        if fs.existsSync filepath
          fs.unlinkSync filepath

    module:
      help: ->
        checkable run(
          "module"
        )

      install: (name) ->
        checkable run(
          "module"
          "install"
          name
          "--moduleApiHost=https://modules-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        )

