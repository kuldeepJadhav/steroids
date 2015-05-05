TestHelper = require "../test_helper"

fs = require("fs")
path = require("path")

# These tests cannot be run if you have not been logged in
skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->

  afterEach =>
    if @testRunDone
      @session.kill()
      @failedSession.kill()

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

    @testRunDone = false

  describe "refresh", =>
    envConfigFilename = path.join(@testHelper.testAppPath, "config", "env.json")
    moduleConfigFilename = path.join(@testHelper.testAppPath, "config", "module.json")

    describe "without running init first", =>
      it 'runs the command which is parsed later in these tests', =>
        runs =>
          fs.unlinkSync envConfigFilename if fs.existsSync envConfigFilename

          @failedSession = @testHelper.runInProject
            args: ["module", "refresh"]

      it "fails with human readable error", =>
        done = false
        waitsFor =>
          done = @failedSession.stdout.match "Please run `steroids module init` first."
        runs =>
          expect(done).toBeTruthy

    describe "when init has already been run", =>

      it 'runs the command which is parsed later in these tests', =>
        runs =>
          @session = @testHelper.runInProject
            args: [
              "module",
              "init",
              "--app-id=5",
              "--auth-token=456",
              "--api-key=abbacd",
              "--envApiHost=https://env-api.devgyver.com"
            ]

      it "writes the module configuration in file", =>
        expect( fs.existsSync moduleConfigFilename ).toBeTruthy()

      it "writes the environment namespace to the module config file", =>
        config = require moduleConfigFilename

        expect( config.environment ).toBeTruthy()

      it 'writes the module config when running module refresh', =>
        fs.unlinkSync moduleConfigFilename

        @testHelper.runInProject
          args: [
            "module",
            "refresh"
            "--envApiHost=https://env-api.devgyver.com"
          ]

        runs =>
          expect( fs.existsSync(moduleConfigFilename) ).toBeTruthy()
