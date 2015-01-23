TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"
onlyWhen process.platform, "darwin"
skipWhen process.env.STEROIDS_TEST_RUN_ENVIRONMENT, "travis"

describe 'genymotion', ->

  describe 'start', =>

    afterEach =>
      if @testRunDone
        @session.kill()

        TestHelper.run
          cmd: "pkill"
          args: ["player"]

        TestHelper.run
          cmd: "pkill"
          args: ["adb"]


    rightHereRightNow =>
      @testHelper = new TestHelper
      @testHelper.prepare()

      @done = false

    it 'starts the run', =>
      # this can not be in rightHereRightNow, because there is no jasmine
      @session = @testHelper.runInProject
        args: ["emulate", "genymotion", "--debug"]
        waitsFor: 100

      running = false
      waitsFor =>
        running = @session.stdout.match /running, becoming the global genymotion/

      runs ->
        expect( running ).toBeTruthy()

    it 'starts the player', =>
      started = false
      waitsFor =>
        started = @session.stdout.match /starting player/

      runs ->
        expect( started ).toBeTruthy()

    it 'finds the device', =>
      device = false
      waitsFor =>
        device = @session.stdout.match /device found/

      runs ->
        expect( device ).toBeTruthy()

    it 'uninstalls', =>
      uninstall = false
      waitsFor =>
        uninstall = @session.stdout.match /uninstalling application/

      runs ->
        expect( uninstall ).toBeTruthy()

    it 'installs', =>
      install = false
      waitsFor =>
        install = @session.stdout.match /installed/

      runs ->
        expect( install ).toBeTruthy()

    it 'started application', =>
      started = false
      waitsFor =>
        started = @session.stdout.match /started application/

      runs ->
        expect( started ).toBeTruthy()

    it 'unlocks the device', =>
      unlocked = false
      waitsFor =>
        unlocked = @session.stdout.match /unlock exit code: 0/

      runs =>
        expect( unlocked ).toBeTruthy()
        @testRunDone = true
