fs = require "fs"
path = require "path"

TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

  deploymentDescriptionFilename = path.join(@testHelper.testAppPath, "config", "deployment.json")
  readModuleDescription = ->
    JSON.parse fs.readFileSync deploymentDescriptionFilename

  describe "deploy", =>

    describe "when running for the first time", =>
      it "creates a deployment description", =>
        cmd = @testHelper.runInProject
          args: [
            "module",
            "deploy",
            "--moduleApiHost=https://modules-api.devgyver.com"
          ]

        waitsFor ->
          cmd.done

        runs ->
          expect(fs.existsSync deploymentDescriptionFilename).toBeTruthy()
