TestHelper = require "../test_helper"

describe 'make', ->

  beforeEach =>
    @testHelper = new TestHelper
    @testHelper.prepare()

  it 'creates the dist', =>
    fs = require "fs"
    path = require "path"
    wrench = require "wrench"

    distPath = path.join(@testHelper.testAppPath, "dist")
    wrench.rmdirSyncRecursive(distPath, true)

    session = @testHelper.runInProject
      args: ["make"]

    runs ->
      expect( fs.existsSync(distPath) ).toBe(true)

  it "fails gracefully with an incorrect config file", =>
    fs = require "fs"
    path = require "path"

    configPath = path.join(@testHelper.testAppPath, "config", "app.coffee")
    fs.appendFileSync configPath, "\n\n dolan"

    session = @testHelper.runInProject
      args: ["make"]

    gracefulError = false
    waitsFor =>
      gracefulError = session.stderr.match /Could not parse.*\n+.*dolan is not defined/

    runs ->
      expect( gracefulError ).toBeTruthy()
