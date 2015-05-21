paths = require "./paths"
grunt = require "grunt"

class Grunt
  constructor: ()->

  run: (options = {}, done = null) ->

    gruntOptions = {}
    gruntTasks = options.tasks || ["default"]

    new Promise (resolve) ->
      grunt.tasks gruntTasks, gruntOptions, done || resolve

module.exports = Grunt
