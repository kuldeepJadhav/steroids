paths = require "../paths"
Help = require "../Help"

module.exports = class LegacyConfig

  constructor: ->
    @editor = {}

    @statusBar =
      style: "black"
      enabled: false

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

    @theme = "black"

    @location = "http://localhost/index.html"

    @preloads = []
    @drawers = {}
    @initialView = null

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

  getCurrent: () ->
    # needs to use global, because application.coffee needs to stay require free

    configPath = paths.application.configs.application
    delete require.cache[configPath] if require.cache[configPath]

    global.steroids =
      config: new LegacyConfig

    try
      require configPath
    catch error
      Help.error()
      console.error "Could not parse #{configPath}. Please ensure it is valid CoffeeScript. \n\n#{error}"
      process.exit 1


    return global.steroids.config
