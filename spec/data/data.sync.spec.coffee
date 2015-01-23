TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"
skipWhen process.env.STEROIDS_TEST_RUN_ENVIRONMENT, "travis"

describe 'data', ->

  afterEach ->
    if @testRunDone
      console.log "DONNNEEE"
      @session.kill()

  rightHereRightNow =>
    @testHelper = new TestHelper
    @testHelper.prepare()

    @testRunDone = false

  describe "sync", =>

    it 'deploys, data inits and data syncs the project', =>

      runs =>
        @testHelper.runInProject
          args: ["deploy"]
          timeout: 600000
          # debug: true

        runs =>
          @testHelper.runInProject
            args: ["data", "init"]
            # debug: true

          runs =>
            @session = @testHelper.runInProject
              args: ["data", "sync", "--debug"]
              # debug: true

    it "gets new configuration from cloud", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("getting current data configuration from cloud")

      runs =>
        expect( done ).toBeTruthy()

    it "acually succeeds in getting new configuration from cloud", =>
      done = false
      waitsFor =>
        done = @session.stdout.match("Getting current data configuration from cloud returned success")

      runs =>
        expect( done ).toBeTruthy()

    it "writes the configuration to config/cloud-resources.raml", =>
      done = false
      waitsFor =>
        done = @session.stdout.match /PROVIDER: writing current data configuration to file: \/.*\/config\/cloud-resources.raml/

      runs =>
        expect( done ).toBeTruthy()

    it "acually succeeds in writing configuration to config/cloud-resouces.raml", =>
      done = false
      waitsFor =>
        done = @session.stdout.match /PROVIDER: Wrote current data configuration to file: \/.*\/config\/cloud-resources.raml/

      runs =>
        expect( done ).toBeTruthy()

    it "acually creates a config/cloud-resources.raml file", =>
      runs =>
        fs = require "fs"
        path = require "path"

        expect(fs.existsSync path.join(@testHelper.testAppPath, "config", "cloud-resources.raml")).toBe true

    it "kills the testrun", =>
      @testRunDone = true
