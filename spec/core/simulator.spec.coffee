TestHelper = require "../test_helper"

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"
onlyWhen process.platform, "darwin"
skipWhen process.env.STEROIDS_TEST_RUN_ENVIRONMENT, "travis"

describe 'simulator', ->

  describe 'start', =>

    afterEach =>
      if @testRunDone
        TestHelper.run
          cmd: "pkill"
          args: ["ios-sim"]

        @session.kill()

    rightHereRightNow =>
      @testHelper = new TestHelper
      @testHelper.prepare()
      @testRunDone = false

    describe 'without connect', =>
      it 'requires that steroids connect is running', =>
        sessionWithoutConnect = @testHelper.runInProject
          args: ["emulate", "ios", "--debug"]

        errored = false
        waitsFor =>
          errored = sessionWithoutConnect.stdout.match "Please run steroids connect before running emulators."

        runs ->
          expect( errored ).toBeTruthy()

    describe 'with connect', =>

      it 'starts connect', =>
        @connectSession = @testHelper.runInProject
          args: ["connect"]
          allowNeverExit: true

        wakeup = false

        request = require "request"

        pollIntervalId = setInterval ->
          console.log "Polling for connect, is it alive?"
          request.get {url: 'http://localhost:4567/appgyver/api/applications/1.json', json: true}, (err, res, body)=>
            if body
              wakeup = true
              console.log "connect is alive"
        , 500

        waitsFor ->
          wakeup
        , 10000

        runs ->
          console.log "Stopping polling"
          clearInterval(pollIntervalId)

      it 'starts the run', =>
        # this can not be in rightHereRightNow, because there is no jasmine
        @session = @testHelper.runInProject
          args: ["emulate", "ios", "--debug"]
          allowNeverExit: true

        running = false
        waitsFor =>
          running = @session.stdout.match "ios-sim/bin/ios-sim"

        runs ->
          expect( running ).toBeTruthy()

      it 'starts with iPhone-6 as the default device', =>
        correctDevice = false
        waitsFor =>
          correctDevice = @session.stdout.match "--devicetypeid,com.apple.CoreSimulator.SimDeviceType.iPhone-6"

        runs ->
          expect( correctDevice ).toBeTruthy()

      it 'starts the session', =>
        started = false
        waitsFor =>
          started = @session.stdout.match "\nSession started"
        , 20000

        runs ->
          expect( started ).toBeTruthy()

        @testRunDone = true


    describe 'options', =>

      beforeEach =>
        @testHelper = new TestHelper
        @testHelper.prepare()

      afterEach =>
        if @testRunDone
          TestHelper.run
            cmd: "pkill"
            args: ["ios-sim"]

          TestHelper.run
            cmd: "pkill"
            args: ["iOS Simulator"]

      it 'launches an iPad-2', =>
        session = @testHelper.runInProject
          args: ["emulate", "ios", "--device=iPad-2", "--debug"]
          waitsFor: 100

        startsIpad2 = false
        waitsFor =>
          startsIpad2 = session.stdout.match "--devicetypeid,com.apple.CoreSimulator.SimDeviceType.iPad-2"

        runs ->
          expect( startsIpad2 ).toBeTruthy()
          session.kill()
          @testRunDone = true

    describe 'shutdown', =>

      it 'shuts connect down', =>
        console.log "killing connect"
        @connectSession.kill()
