TestHelper = require "../test_helper"


describe 'connect', ->

  describe 'start', ->

    rightHereRightNow =>
      @testHelper = new TestHelper
      @testHelper.prepare()
      @testRunDone = false

    afterEach =>
      if @testRunDone
        @session.kill()

    it "starts the connect prompt", =>
      @session = @testHelper.runInProject
        args: ["connect", "--no-connect-screen", "--debug"]
        waitsFor: 100

      started = false
      waitsFor =>
        started = @session.stdout.match("______/  |_  ___________  ____ |__| __| _/______")

      runs =>
        expect( started ).toBeTruthy()

    it "pushes", =>
      pushed = false
      waitsFor =>
        pushed = @session.stdout.match("Starting push")

      runs =>
        expect( pushed ).toBeTruthy()

    it "makes", =>
      maked = false
      waitsFor =>
        maked = @session.stdout.match("one, without errors.")

      runs =>
        expect( maked ).toBeTruthy()

    it "packages", =>
      packaged = false
      waitsFor =>
        packaged = @session.stdout.match("Zip created, timestamp")

      runs =>
        expect( packaged ).toBeTruthy()

    it "kills iOS simulator", =>
      unless process.platform == "darwin"
        console.log "skipping because not in os x"
        return
        
      killediOS = false
      waitsFor =>
        killediOS = @session.stdout.match("Killed iOS Simulator")

      runs =>
        expect( killediOS ).toBeTruthy()

    it "kills genymotion", =>
      return # Disabled
      killedGenymotion = false
      waitsFor =>
        killedGenymotion = @session.stdout.match("Killed genymotion")

      runs =>
        expect( killedGenymotion ).toBeTruthy()

    it "kills genymotion", =>
      return # Disabled
      killedAndroid = false
      waitsFor =>
        killedAndroid = @session.stdout.match("Killed android")

      runs =>
        expect( killedAndroid ).toBeTruthy()

    it "shows help", =>
      helpShown = false
      waitsFor =>
        helpShown = @session.stdout.match("Push code to connected devices")

      runs =>
        expect( helpShown ).toBeTruthy()

    it "waits for input", =>
      promptVisible = false

      waitsFor =>
        first = @session.stdout.match("AppGyver Steroids")
        second = @session.stdout.match("ommand")
        promptVisible = first and second

      runs =>
        expect( promptVisible ).toBeTruthy()

    it "has started the build server", =>
      request = require "request"

      applicationJSON = null

      request.get {url: 'http://localhost:4567/appgyver/api/applications/1.json', json: true}, (err, res, body)=>
        applicationJSON = body

      waitsFor ->
        applicationJSON

      runs ->
        expect( applicationJSON.id ).toBe(1)

    it "is the final test", =>
      @testRunDone = true
