Help = require "./Help"

class Usage

  constructor: (@opts={}) ->

  run: ->
    Help = require "./Help"

    Help.usage.header()
    Help.usage.compact()

    if @opts.extended
      Help.usage.extended()
      Help.usage.create()
      Help.usage.emulate()
      Help.usage.log()
      Help.usage.module()
      console.log "Generator usage:"
      Help.listGenerators()
      console.log "\n"

    Help.usage.footer()

  emulate: ->
    Help.usage.emulate()

  debug: ->
    Help.usage.debug()

  log: ->
    Help.usage.log()

  module: ->
    Help.usage.module()

module.exports = Usage
