spawn = require("child_process").spawn

class CommandRunner

  constructor: (@options)->
    @cmd = @options.cmd
    @args = @options.args || []
    @cwd = @options.cwd || ""

    @timeout = @options.timeout || 20000

    @stdout = ""
    @stderr = ""
    @done = false   # always true after exit, even in failure
    @success = false
    @code = null

    @options.debug = true if process.env["STEROIDS_TEST_DEBUG"]?

  run:() =>
    if @options.debug
      now = new Date
      console.log "#{now.toISOString()} - starting cmd: #{@cmd}, args: #{@args}, cwd: #{@cwd}"

    @spawned = spawn @cmd, @args, { cwd: @cwd }

    @spawned.stdout.on "data", (buffer) =>
      newData = buffer.toString()
      @stdout = @stdout + newData

      console.log newData if @options.debug

    @spawned.stderr.on "data", (buffer) =>
      newData = buffer.toString()

      if /^execvp\(\)/.test(newData)
        console.log "!!! CommandRunner: failed to start process #{@cmd}"
        @done = true
        return

      @stderr = @stderr + newData
      console.log newData if @options.debug


    @spawned.on "exit", (code) =>
      @code = code
      @success = true
      @done = true

    if @options.waitsFor
      setTimeout ()=>
        @done = true
      , @options.waitsFor

    if @options.allowNeverExit
      console.log "Allowing #{@cmd} to never exit"
    else
      waitsFor(()=>
        return @done
      , "CommandRunner: cmd never exited", @timeout)

  kill:() =>
    @spawned.kill('SIGKILL')

module.exports = CommandRunner
