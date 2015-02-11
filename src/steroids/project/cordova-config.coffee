_ = require "lodash"
paths = require "../paths"
features = require '../features'
Help = require '../Help'

class CordovaConfig

  constructor: ->
    @editor = {}

    @statusBar =
      style: "black"
      enabled: false

    @theme = "black"

    @location = null

    @preloads = []
    @drawers = {}
    @initialView = null

    @navigationBar =
      portrait:
        backgroundImage:          ""
      landscape:
        backgroundImage:          ""
      tintColor:                  ""
      titleColor:                 ""
      titleShadowColor:           ""

      buttonTitleColor:           ""
      buttonShadowColor:          ""
      buttonTintColor:            ""

      borderSize:                 ""
      borderColor:                ""

    @tabBar =
      enabled:                    false
      backgroundImage:            ""
      tintColor:                  ""
      tabTitleColor:              ""
      tabTitleShadowColor:        ""
      selectedTabTintColor:       ""
      selectedTabBackgroundImage: ""
      tabs: []

    @loadingScreen =
      tintColor: ""

    @worker =  {}   # what is this?

    @hooks =
      preMake: {}
      postMake: {}

    @watch =
      exclude: []

    # Project files that will be copied to a writable UserFiles directory.
    # File is copied only if it doesn't yet exist in the UserFiles directory.
    @copyToUserFiles = []

  getStartLocation: ->
    xml2js = require "xml2js"
    fs = require "fs"

    parser = new xml2js.Parser()
    configXmlData = fs.readFileSync paths.cordovaSupport.configXml

    location = null
    parser.parseString configXmlData, (err, result) ->
      if err
        throw new Error err.message

      location = result?.widget?.content?[0].$?.src || "index.html"

    "http://localhost/#{location}"

  getCurrent: =>
    try
     @location = @getStartLocation()
    catch error
      Help.error()
      console.error """
        Could not parse configuration for your Cordova project.
        Please ensure the file at #{paths.cordovaSupport.configXml} is valid XML.

        #{error}
        """

      process.exit 1

    @

module.exports = CordovaConfig
