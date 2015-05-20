fs = require "fs"
path = require "path"

TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

  describe "deploy", =>
    moduleDescriptionFilename = path.join(@testHelper.testAppPath, "config", "module.json")

    describe "when running for the first time", =>
      it "creates a file to store details about the deployed module", =>
        cmd = @testHelper.runInProject
          args: [
            "module",
            "deploy",
            "--moduleApiHost=https://modules-api.devgyver.com"
          ]

        waitsFor ->
          cmd.done

        runs ->
          expect(fs.existsSync moduleDescriptionFilename).toBeTruthy()
