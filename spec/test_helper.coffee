wrench = require "wrench"
fs = require "fs"
path = require "path"

CommandRunner = require "./command_runner"

# https://github.com/mhevery/jasmine-node/pull/142
require "./monkeypatch_timeout"

greatContains = (givenItem, arrayOrString) ->
  items = if arrayOrString.constructor.name == "String"
    [arrayOrString]
  else
    arrayOrString

  for item in items
    return true if item == givenItem

  false

global.skipWhen = (what, givens) ->
  if greatContains(what, givens)
    console.log "#{what} is in #{givens}, skipping this test"
    process.exit(0)
  else
    console.log "#{what} is not in #{givens}, running this test"

global.onlyWhen = (what, givens) ->
  if greatContains(what, givens)
    console.log "#{what} is in #{givens}, running this test"
  else
    console.log "#{what} is not in #{givens}, skipping this test"
    process.exit(0)



global.rightHereRightNow = (f) =>
  f()

class TestHelper
  @CommandRunner: CommandRunner
  @steroidsBinPath: path.join __dirname, "..", "bin", "steroids"

  @run: (options={}) =>
    options.cmd ?= TestHelper.steroidsBinPath

    commandRun = new CommandRunner options
    commandRun.run()

    return commandRun

  run: @run

  constructor: (@options = {}) ->
    testDirectory = @options.relativePath || "__test"
    @testAppName = @options.testAppName || "testApp"
    @testBaseApp = @options.testBaseApp || "__testApp"
    @workingDirectory = path.join process.cwd(), testDirectory
    @testAppPath = path.join(@workingDirectory, @testAppName)

  prepare: () =>
    @bootstrap()
    @copyBaseApp()

  bootstrap: () =>
    wrench.rmdirSyncRecursive @workingDirectory, true
    fs.mkdirSync @workingDirectory

  changeToWorkingDirectory: () =>
    process.chdir @workingDirectory

  copyBaseApp: =>
    wrench.copyDirSyncRecursive @testBaseApp, path.join(@workingDirectory, @testAppName)

  cleanUp: () =>
    if process.cwd() == @workingDirectory
      process.chdir path.join process.cwd(), ".."

    wrench.rmdirSyncRecursive @workingDirectory, false

  createProjectSync: () =>

    @createRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["create", @testAppName]
      timeout: 20000
      debug: @options.debug

    runs ()=>
      @createRun.run()

    runs ()=>
      expect( @createRun.done ).toBe(true)



  runInProject: (options={})=>
    options.cmd ?= TestHelper.steroidsBinPath
    options.cwd ?= @testAppPath

    commandRun = new CommandRunner options
    commandRun.run()

    return commandRun

  runMakeInProjectSync: () =>
    cmd = @runInProjectSync "make"

    runs ()=>
      expect( cmd.done ).toBe(true)


  runPackageInProjectSync: () =>
    cmd = @runInProjectSync "package"

    runs ()=>
      expect( cmd.done ).toBe(true)

  runConnect: () =>
    @connectRun = @runInProjectSync "connect",
      waitsFor: 3000

    runs () =>
      @requestServerInterval = setInterval(()=>
        require("request").get 'http://localhost:4567/appgyver/api/applications/1.json', (err, res, body)=>
          if err is null
            @running = true
            clearInterval @requestServerInterval
      , 250)

    waitsFor(()=>
      return @running
    , "Command 'connect' should complete", 6000)

  killConnect: () =>
    @connectRun.kill() if @connectRun

module.exports = TestHelper
