fs = require 'fs'
path = require 'path'

inquirer = require "inquirer"
chalk = require 'chalk'

Help = require "../Help"
ProjectCreator = require "./ProjectCreator"
createModuleProject = require '../module/commands/create'

module.exports = runCreateCommand = (targetDirectory, argv) ->

  fullPath = getWritableTargetPath targetDirectory
  steroidsCli.debug "Creating a new project in #{chalk.bold fullPath}..."

  askCreateQuestions(argv).then (answers) ->
    if answers.type is 'module'
      createModuleProject {
        moduleName: targetDirectory
      }
    else
      createApplicationProject({
        targetDirectory
        type: answers.type
        language: answers.language
      }).then ->
        steroidsCli.log """
          #{chalk.bold.green('\nSuccesfully created a new Steroids project!')}

          Run #{chalk.bold("cd "+ targetDirectory)} and then #{chalk.bold('steroids connect')} to start building your app!
        """

getWritableTargetPath = (targetDirectory) ->
  unless targetDirectory?
    steroidsCli.log "Usage: steroids create <directoryName>"
    process.exit(1)

  fullPath = path.join process.cwd(), targetDirectory

  if fs.existsSync fullPath
    Help.error()
    steroidsCli.log "Directory #{chalk.bold(targetDirectory)} already exists. Remove it to continue."
    process.exit(1)

  fullPath

askCreateQuestions = (argv) ->
  prompts = []

  unless argv.type
    typePrompt =
      type: "list"
      name: "type"
      message: "What do you want to create?"
      choices: [
        { name: "Multi-Page Application (Supersonic default)", value: "mpa" }
        { name: "Single-Page Application (for use with other frameworks)", value: "spa"}
        { name: "Custom Module (for use with Composer 2)", value: "module"}
      ]
      default: "mpa"

    prompts.push typePrompt

  unless argv.language
    languagePrompt =
      type: "list"
      name: "language"
      message: "Do you want your project to be generated with CoffeeScript or JavaScript files?"
      choices: [
        { name: "CoffeeScript", value: "coffee" }
        { name: "JavaScript", value: "js"}
      ]
      default: "coffee"
      when: (answers) ->
        answers.type isnt 'module'

    prompts.push languagePrompt

  new Promise (resolve) ->
    inquirer.prompt prompts, (answers) ->
      answers.type ?= argv.type
      answers.language ?= argv.language

      resolve answers

createApplicationProject = (options) ->
  projectCreator = new ProjectCreator options

  projectCreator.run().then ->
    projectCreator.update()
