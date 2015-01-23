TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"
skipWhen process.env.STEROIDS_TEST_RUN_ENVIRONMENT, "travis"

describe 'data', ->

  afterEach =>
    if @testRunDone
      @session.kill()

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

    @testRunDone = false

  describe 'init', =>

    it 'updates, deploys and data inits the project', =>
      runs =>
        #TODO: extract
        @testHelper.runInProject
          args: ["update"]
          timeout: 600000
          # debug: true

        runs =>
          @testHelper.runInProject
            args: ["deploy"]
            timeout: 600000
            # debug: true

          runs =>
            @session = @testHelper.runInProject
              args: ["data", "init", "--debug"]
              # debug: true

    it "notices that config/sandboxdb.yaml is missing", =>
      done = false
      waitsFor =>
        done = @session.stdout.match(/Configuration file \/.*\/config\/sandboxdb.yaml was missing/)

      runs =>
        expect( done ).toBeTruthy()

    it "provisions a new sandboxdb", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("Provisioning Sandbox DB")

      runs =>
        expect( done ).toBeTruthy()

    it "acually succeeds in provisioning a new sandboxdb", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("Provisioned Sandbox DB")

      runs =>
        expect( done ).toBeTruthy()

    it "writes the sandboxdb configuration to config/sandboxdb.yaml", =>
      done = false
      waitsFor =>
        done = @session.stdout.match(/Writing configuration to file \/.*\/config\/sandboxdb.yaml/)

      runs =>
        expect( done ).toBeTruthy()

    it "acually succeeds in writing to config/sandboxdb.yaml", =>
      done = false
      waitsFor =>
        done = @session.stdout.match(/Writing configuration to file \/.*\/config\/sandboxdb.yaml was success/)

      runs =>
        expect( done ).toBeTruthy()

    it "checks for a sandboxdb provider from the cloud", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("PROVIDER: Getting a provider for backend AppGyver Sandbox Database")

      runs =>
        expect( done ).toBeTruthy()

    it "notices that provider for sandboxdb is not yet created", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("provider for backend 6 not found, creating a new one")

      runs =>
        expect( done ).toBeTruthy()

    it "creates a new provider to cloud", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("PROVIDER: Creating a new provider AppGyver Sandbox Database ID: 6 to cloud returned success: {")

      runs =>
        expect( done ).toBeTruthy()

    it "acually succeeds in creating a new provider", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("provider for backend 6 created")

      runs =>
        expect( done ).toBeTruthy()

    it "acually creates a config/sandboxdb.yaml file", =>
      runs =>
        fs = require "fs"
        path = require "path"

        expect(fs.existsSync path.join(@testHelper.testAppPath, "config", "sandboxdb.yaml")).toBe true

    it "kills the testrun", =>
      @testRunDone = true
