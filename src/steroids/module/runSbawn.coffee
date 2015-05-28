sbawn = require '../sbawn'

class SbawnError extends steroidsCli.SteroidsError
  constructor: (@session) ->
    super "Process exited with code #{@session.code}"

module.exports = runSbawn = (cmd, args = [], params = {}) ->
  new Promise (resolve, reject) ->
    session = sbawn
      cmd: cmd
      args: args
      stdout: params.stdout || true
      stderr: params.stderr || true

    session.on 'exit', ->
      if session.code isnt 0
        reject new SbawnError session
      else
        resolve session
