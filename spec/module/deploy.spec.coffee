fs = require "fs"
path = require "path"

deepEqual = require 'deep-equal'

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

  getCurrentVersion = ->
    deploymentDescriptionFile.readJson().versions?[0]?.version

  getLastUploadTimestamp = ->
    deploymentDescriptionFile.readJson().versions?[0]?.module_zip_last_uploaded_at

  describe "deploy", =>

    describe "when running for the first time", =>
      it "creates a deployment description and runs grunt", =>
        cmd = @testHelper.runInProject
          args: [
            "module",
            "deploy",
            "--moduleApiHost=https://modules-api.devgyver.com"
            "--accessToken=#{process.env.STEROIDS_DEVGYVER_ACCESS_TOKEN}"
          ]

        waitsFor ->
          cmd.done

        runs ->
          expect(deploymentDescriptionFile.exists()).toBeTruthy()

          expect(cmd.stdout.match /Running "[^"]+" task/).toBeTruthy()

      describe "deployment description", ->
        it "should have an identifier for the module", ->
          expect(deploymentDescriptionFile.readJson().id).toBeTruthy()

        it "should have a version identifier", ->
          expect(getCurrentVersion()).toBeTruthy()

        it "should have a last upload timestamp", ->
          expect(getLastUploadTimestamp()).toBeTruthy()

    describe "when already deployed once", =>
      it "updates the deployment description and runs grunt", =>
        deploymentDescription = deploymentDescriptionFile.readJson()

        cmd = @testHelper.runInProject
          args: [
            "module",
            "deploy",
            "--moduleApiHost=https://modules-api.devgyver.com"
            "--accessToken=#{process.env.STEROIDS_DEVGYVER_ACCESS_TOKEN}"
          ]

        waitsFor ->
          cmd.done

        runs ->
          freshDeploymentDescription = deploymentDescriptionFile.readJson()
          expect(deepEqual(freshDeploymentDescription, deploymentDescription)).toBeFalsy()

          expect(cmd.stdout.match /Running "[^"]+" task/).toBeTruthy()

      describe "deployment description", =>
        it "should have an identifier for the module", =>
          expect(deploymentDescriptionFile.readJson().id).toBeTruthy()

        it "has an incremented current version and last upload timestamp", =>
          lastDeployment = {
            version: getCurrentVersion()
            timestamp: getLastUploadTimestamp()
          }

          cmd = @testHelper.runInProject
            args: [
              "module",
              "deploy",
              "--moduleApiHost=https://modules-api.devgyver.com"
              "--accessToken=#{process.env.STEROIDS_DEVGYVER_ACCESS_TOKEN}"
            ]

          waitsFor ->
            cmd.done

          runs ->
            expect(deepEqual(
              lastDeployment
              {
                version: getCurrentVersion()
                timestamp: getLastUploadTimestamp()
              }
            )).toBeFalsy()

