TestHelper = require "../test_helper"

fs = require "fs"
path = require "path"

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
            args: ["module", "init", "--app-id=", "--auth-token", ""]

      it "fails with human readable error", =>
        done = false
        waitsFor =>
          done = @failedSession.stdout.match "Please run again with"
        runs =>
          expect(done).toBeTruthy()

    describe "successfully", =>
      it 'runs the command which is parsed later in these tests', =>
        @session = @testHelper.runInProject
          args: ["module", "init", "--app-id=123", "--auth-token=456", "--api-key=abbacd", "--user-id=789"]

      it "writes the configuration in file", =>
        expect( fs.existsSync envConfigFilename ).toBeTruthy()

      it "writes given parameters to the env file", =>
        config = require envConfigFilename

        expect( config.appId ).toEqual 123
        expect( config.authToken ).toEqual 456
        expect( config.userId ).toEqual 789
        expect( config.apiKey ).toEqual "abbacd"
