TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"

module.exports = steroids = ->
  testHelper = new TestHelper
  testHelper.prepare()

  module:
    install: (name) ->
      runner = testHelper.runInProject
        args: [
          "module",
          "install",
          name,
          "--moduleApiHost=https://modules-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        ]

      check: (runnerAssertions) ->
        waitsFor ->
          runner.done

        runs ->
          runnerAssertions? runner
