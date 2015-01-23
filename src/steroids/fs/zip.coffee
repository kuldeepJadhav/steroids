path = require "path"
Paths = require "./../paths"
childProcess = require "child_process"
wrench = require "wrench"
fs = require "fs"

class Zip
  constructor: (@from, @to, @filesOutsideSourceDirectory)->

  create: (callback)->
    @zipRecursively callback

  zipRecursively: (callback)->

    steroidsCli.debug "Removing existing zip..."

    if fs.existsSync @to
      fs.unlinkSync @to
      steroidsCli.debug "Existing zip found and removed."

    # use 7zip on windows
    if process.platform is "win32"

      steroidsCli.debug "Zipping with 7zip..."

      zipCommand = path.join Paths.vendor, "7zip", "7za"
      fromPath = path.join @from, "*"
      zipArgs = ["a", @to, fromPath]
      zip = childProcess.spawn zipCommand, zipArgs

      zip.on "close", (code, signal)->
        timestamp = (new Date).getTime()
        steroidsCli.debug "Zip created, timestamp: #{timestamp}"

        callback.apply(null, [timestamp]) if callback?

    # use OS supplied zip on OSX/Linux
    else

      steroidsCli.debug "Zipping with OS supplied zip..."

      child = childProcess.exec "find . -print | zip -@ -FS #{@to}", {
        cwd: @from,
        maxBuffer: 1024 * 1000
      }, (error, stdout, stderr)->
        throw error if error?
        steroidsCli.debug stdout

        timestamp = (new Date).getTime()
        steroidsCli.debug "Zip created, timestamp: #{timestamp}"

        callback.apply(null, [timestamp]) if callback?

module.exports = Zip
