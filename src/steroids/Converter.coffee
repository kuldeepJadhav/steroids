fs = require "fs"

Paths = require "./paths"
Config = require "./project/config"
CloudConfig = require "./CloudConfig"
routingHelpers = require "./routingHelpers"

class Converter
  constructor: (@configPath)->

  configToAnkaFormat: ->

    @config = new Config()
    configObject = @config.getCurrent()

    cloudConfig = new CloudConfig().getCurrentSync()
    cloudId = if cloudConfig
      cloudConfig.id
    else
      1

    ankaLikeJSON =
      id: cloudId
      name: configObject.name||"Default name"

    if fs.existsSync Paths.temporaryZip
      ankaLikeJSON.build_timestamp = fs.lstatSync(Paths.temporaryZip).mtime.getTime()

    ankaLikeJSON.configuration = @configurationObject(configObject)
    ankaLikeJSON.appearance = @appearanceObject(configObject)
    ankaLikeJSON.preloads = @preloadsObject(configObject)
    ankaLikeJSON.drawers = @drawersObject(configObject)
    ankaLikeJSON.configuration.extra_response_headers = @extraHeadersObject(configObject)

    # runtime crashes with empty initialView object
    initialViewObject = @initialViewObject(configObject)
    if initialViewObject?
      ankaLikeJSON.initialView = initialViewObject

    # supersonic stuff
    ankaLikeJSON.rootView = @rootViewObject(configObject)

    ankaLikeJSON.files = []
    ankaLikeJSON.archives = []

    ankaLikeJSON.bottom_bars = ankaLikeJSON.tabs = @tabsObject(configObject)

    return ankaLikeJSON

  extraHeadersObject: (config) =>
    @config.eitherSupersonicOrLegacy().fold(
      ->
        config.network?.extraResponseHeaders
      ->
        {}
    )

  tabsObject: (config) =>
    @config.eitherSupersonicOrLegacy().fold(
      ->
        tabs = []

        if config.structure.tabs?
          for configTab, i in config.structure.tabs
            tab =
              position: i
              id: configTab.id
              title: configTab.title
              image_path: configTab.icon
              target_url: routingHelpers.parseLocation(configTab.location)
            tabs.push tab

        tabs
      ->
        tabs = []

        if config.tabBar.enabled
          for configTab, i in config.tabBar.tabs
            tab =
              position: i
              id: configTab.id
              title: configTab.title
              image_path: configTab.icon
              target_url: configTab.location
            tabs.push tab

        tabs
    )

  configurationObject: (config) =>
    {statusBar, fullscreen, location} =
      @config.eitherSupersonicOrLegacy().fold(
        ->
          statusBar:
            if not config.statusBar?
              "default"
            else if config.statusBar?.enabled == false
              "hidden"
            else
              config.statusBar.style || "default"
          fullscreen: !(config.structure.tabs?)
          location: if config.structure.rootView?.location?
            routingHelpers.parseLocation(config.structure.rootView.location)
          else
            ""
        ->
          statusBar:
            if config.statusBar?.enabled == false or config.statusBar?.enabled == undefined
              "hidden"
            else
              config.statusBar.style
          fullscreen: config.tabBar.enabled == false
          location: config.location
      )

    return {
      fullscreen: fullscreen
      fullscreen_start_url: location
      status_bar_style: statusBar
      request_user_location: "false"
      splashscreen_duration_in_seconds: 0
      client_version: "edge"
      navigation_bar_style: "black"
      initial_eval_js_string: ""
      background_eval_js_string: ""
      wait_for_document_ready_before_open: "true"
      open_clicked_links_in_new_layer: "false"
      shake_gesture_enabled_during_development: "false"
      copy_to_user_files: @userFilesObject(config)
    }

  appearanceObject: (config)->
    @config.eitherSupersonicOrLegacy().fold(
      ->
        null
      ->
        appearanceObject =
          nav_bar_portrait_background_image: "#{config.navigationBar.portrait.backgroundImage}"
          nav_bar_landscape_background_image: "#{config.navigationBar.landscape.backgroundImage}"
          nav_bar_tint_color: "#{config.navigationBar.tintColor}"
          nav_bar_title_text_color: "#{config.navigationBar.titleColor}"
          nav_bar_title_shadow_color: "#{config.navigationBar.titleShadowColor}"
          nav_bar_button_tint_color: "#{config.navigationBar.buttonTintColor}"
          nav_bar_button_title_text_color: "#{config.navigationBar.buttonTitleColor}"
          nav_bar_button_title_shadow_color: "#{config.navigationBar.buttonShadowColor}"
          tab_bar_background_image: "#{config.tabBar.backgroundImage}"
          tab_bar_tint_color: "#{config.tabBar.tintColor}"
          tab_bar_button_title_text_color: "#{config.tabBar.tabTitleColor}"
          tab_bar_button_title_shadow_color: "#{config.tabBar.tabTitleShadowColor}"
          tab_bar_selected_icon_tint_color: "#{config.tabBar.selectedTabTintColor}"
          tab_bar_selected_indicator_background_image: "#{config.tabBar.selectedTabBackgroundImage}"
          loading_screen_color: "#{config.loadingScreen.tintColor}"

        # legacy support: bug in 3.1.5 client causes empty strings for these values to crash
        unless config.navigationBar.borderSize is null or config.navigationBar.borderSize is ""
          appearanceObject.nav_bar_border_size = "#{config.navigationBar.borderSize}"

        unless config.navigationBar.borderColor is null or config.navigationBar.borderColor is ""
          appearanceObject.nav_bar_border_color = "#{config.navigationBar.borderColor}"

        appearanceObject
    )

  preloadsObject: (config)->
    @config.eitherSupersonicOrLegacy().fold(
      ->
        if config.structure.preloads?
          preloads = []

          for view in config.structure.preloads
            view.location = routingHelpers.parseLocation(view.location)
            preloads.push view

          preloads
      ->
        config.preloads
    )

  drawersObject: (config)->
    @config.eitherSupersonicOrLegacy().fold(
      ->
        if config.structure.drawers?
          leftDrawer = config.structure.drawers.left
          rightDrawer = config.structure.drawers.right

          for drawer in [leftDrawer, rightDrawer]
            drawer?.location =
              routingHelpers.parseLocation(drawer.location)

          config.structure.drawers
      ->
        config.drawers
    )

  initialViewObject: (config)->
    @config.eitherSupersonicOrLegacy().fold(
      ->
        initView = config.structure.initialView
        initView?.location =
          routingHelpers.parseLocation(initView.location)
        initView
      ->
        config.initialView
    )

  userFilesObject: (config)->
    userFilesObject = []

    if config.copyToUserFiles?
      for file in config.copyToUserFiles
        userFilesObject.push file

    return userFilesObject

  rootViewObject: (config)->
    @config.eitherSupersonicOrLegacy().fold(
      ->
        rootView = config.structure.rootView
        rootView?.location =
          routingHelpers.parseLocation(rootView.location)
        rootView
      ->
        null
    )

module.exports = Converter
