TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"

fs = require("fs")
path = require("path")

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
    moduleConfigFilename = path.join(@testHelper.testAppPath, "config", "appgyver.json")

    describe "without running init first", =>
      it 'runs the command which is parsed later in these tests', =>
        runs =>
          fs.unlinkSync envConfigFilename if fs.existsSync envConfigFilename

          @failedSession = @testHelper.runInProject
            args: ["module", "refresh"]

      it "fails with human readable error", =>
        done = false
        waitsFor =>
          done = @failedSession.stderr.match "Please run `steroids module init` first."
        runs =>
          expect(done).toBeTruthy

    describe "when init has already been run", =>

      it 'runs the command which is parsed later in these tests', =>
        runs =>
          @session = @testHelper.runInProject
            args: [
              "module",
              "init",
              "--app-id=1066",
              "--auth-token=62e937eb1f5870ab5da0cf0dafe2d850",
              "--api-key=60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5",
              "--user-id=1041",
              "--envApiHost=https://env-api.devgyver.com"
              "--oauthTokenPath=#{oauthTokenPath}"
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
            "--oauthTokenPath=#{oauthTokenPath}"
          ]

        runs =>
          expect( fs.existsSync(moduleConfigFilename) ).toBeTruthy()
