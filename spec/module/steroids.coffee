TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"
path = require "path"

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

  return new class SteroidsModuleCommandRunner

    path: (parts...) ->
      path.join(testHelper.testAppPath, parts...)

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

