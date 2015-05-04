TestHelper = require "../test_helper"

fs = require("fs")
path = require("path")

describe "module", ->

  afterEach =>
    if @testRunDone
      @session.kill()
      @failedSession.kill()

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

    @testRunDone = false

  describe "init", =>
    envConfigFilename = path.join(@testHelper.testAppPath, "config", "env.json")

    describe "with invalid options", =>
      it 'runs the command which is parsed later in these tests', =>
        runs =>
          @failedSession = @testHelper.runInProject
            args: ["module", "init", "--app-id=", "--user-id", ""]

      it "fails with human readable error", =>
        done = false
        waitsFor =>
          done = @failedSession.stdout.match "Please run again with"
        runs =>
          expect(done).toBeTruthy

    describe "successfully", =>
      it 'runs the command which is parsed later in these tests', =>
        runs =>
          @session = @testHelper.runInProject
            args: ["module", "init", "--app-id=123", "--user-id=456", "--api-key=abbacd"]

      it "writes the configuration in file", =>
        done = false
        waitsFor =>
          done = fs.existsSync envConfigFilename

        runs =>
          expect( done ).toBeTruthy()

      it "writes given parameters to the env file", =>
        done = false
        config = require envConfigFilename

        runs =>
          expect( config.appId ).toEqual 123
          expect( config.userId ).toEqual 456
          expect( config.apiKey ).toEqual "abbacd"
