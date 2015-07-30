TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"

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
          done = @failedSession.stderr.match "Please run again with"
        runs =>
          expect(done).toBeTruthy()

    describe "successfully", =>
      it 'runs the command which is parsed later in these tests', =>
        @session = @testHelper.runInProject
          args: [
            "module"
            "init"
            "--app-id=1066"
            "--auth-token=62e937eb1f5870ab5da0cf0dafe2d850"
            "--api-key=60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5"
            "--user-id=1041",
            "--envApiHost=https://env-api.devgyver.com"
            "--oauthTokenPath=#{oauthTokenPath}"
          ]

      it "writes the configuration in file", =>
        expect( fs.existsSync envConfigFilename ).toBeTruthy()

      it "writes given parameters to the env file", =>
        config = require envConfigFilename

        expect( config.appId ).toEqual 1066
        expect( config.authToken ).toEqual "62e937eb1f5870ab5da0cf0dafe2d850"
        expect( config.userId ).toEqual 1041
        expect( config.apiKey ).toEqual "60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5"
