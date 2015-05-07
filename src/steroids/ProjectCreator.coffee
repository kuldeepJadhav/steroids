class ProjectCreator

  constructor: (options={})->
    @targetDirectory = options.targetDirectory
    @type = options.type || "mpa"
    @language = options.language || "coffee"

  run: () ->
    new Promise (resolve) =>
      if @type is "module"
        @createModuleProject()
      else
        steroidsGenerator = require "generator-steroids"
        steroidsGenerator.app {
          skipInstall: true
          projectName: @targetDirectory
          appType: @type
          scriptExt: @language
        }, resolve

  update: =>

    new Promise (resolve, reject) =>
      paths = require './paths'
      steroids_cmd = paths.steroids
      steroidsCli.debug "Running #{steroids_cmd} update"

      sbawn = require './sbawn'
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

  createModuleProject: =>
    new Promise (resolve, reject) =>
      sbawn = require "./sbawn"
      paths = require "./paths"
      path = require "path"
      session = sbawn
        cmd: path.join paths.scriptsDir, "createModuleProject.sh"
        args: [@targetDirectory, @language]
        stdout: true
        stderr: true

      session.on 'exit', ->
        if session.code != 0 || session.stdout.match(/npm ERR!/)
          reject new Error "Something went wrong!"

        resolve()

module.exports = ProjectCreator
