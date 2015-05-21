fs = require "fs"
path = require "path"

TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

file = (path) ->
  readJson: -> JSON.parse fs.readFileSync path
  exists: -> fs.existsSync path
  clean: ->
    if fs.existsSync path
      fs.unlinkSync path

describe "module", ->

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

  deploymentDescriptionFile = file path.join(@testHelper.testAppPath, "config", "deployment.json")
  deploymentDescriptionFile.clean()

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
          expect(deploymentDescriptionFile.exists()).toBeTruthy()

      describe "deployment description", ->
        it "should have an identifier for the module", ->
          expect(deploymentDescriptionFile.readJson().module.id).toBeTruthy()
