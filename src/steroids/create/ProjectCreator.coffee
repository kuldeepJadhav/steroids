steroidsGenerator = require "generator-steroids"

paths = require '../paths'
sbawn = require '../sbawn'

class ProjectCreator

  constructor: (options={})->
    @targetDirectory = options.targetDirectory
    @type = options.type || "mpa"
    @language = options.language || "coffee"

  run: () ->
    new Promise (resolve) =>

      steroidsGenerator.app {
        skipInstall: true
        projectName: @targetDirectory
        appType: @type
        scriptExt: @language
      }, resolve

  update: =>

    new Promise (resolve, reject) =>

      steroids_cmd = paths.steroids
      steroidsCli.debug "Running #{steroids_cmd} update"


      session = sbawn
        cmd: steroids_cmd
        args: ["update"]
        debug: steroidsCli.debugEnabled
        stdout: true
        stderr: true

      steroidsCli.log  "\nChecking for Steroids updates and installing project NPM dependencies. Please wait."

      session.on 'exit', ->
        steroidsCli.debug "#{session.cmd} exited with code #{session.code}"

        if session.code != 0 || session.stdout.match(/npm ERR!/)
          reject new Error "\nSomething went wrong - try running #{chalk.bold('steroids update')} manually in the project directory."

        resolve()


module.exports = ProjectCreator
