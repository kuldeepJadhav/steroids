fs = require "fs"

routingHelpers = require "./routingHelpers"
Paths = require "./paths"
Config = require "./project/config"

class DeployConverter

  constructor: ()->
    @configurator = new Config()
    @config = @configurator.getCurrent()

  applicationCloudSchemaRepresentation: =>

    {fullscreen, location} =
      @configurator.eitherSupersonicOrLegacy().fold(
        =>
          fullscreen: not @config.structure.tabs?
          location:
            if @config.structure.rootView?
              routingHelpers.parseLocation(@config.structure.rootView.location)
            else
              ""
        =>
          fullscreen: not @config.tabBar.enabled
          location: @config.location
      )

    name: @projectName() || "New Project"
    framework_id: 13
    navigation_bar_style: @config.theme ? null
    status_bar_style: @statusBarStyle()
    fullscreen: fullscreen
    fullscreen_start_url: location
    client_version: "edge"
    initial_eval_js_string: ""
    background_eval_js_string: ""
    latest_build_built_by: "steroids"
    latest_build_built_at: parseInt(new Date().getTime()/1000)
    nav_bar_portrait_background_image: @config.navigationBar?.portrait?.backgroundImage ? ""
    nav_bar_landscape_background_image: @config.navigationBar?.landscape?.backgroundImage ? ""
    nav_bar_tint_color: @config.navigationBar?.tintColor ? ""
    nav_bar_title_text_color: @config.navigationBar?.titleColor ? ""
    nav_bar_title_shadow_color: @config.navigationBar?.titleShadowColor ? ""
    nav_bar_button_tint_color: @config.navigationBar?.buttonTintColor ? ""
    nav_bar_button_title_text_color: @config.navigationBar?.buttonTitleColor ? ""
    nav_bar_button_title_shadow_color: @config.navigationBar?.buttonShadowColor ? ""
    tab_bar_background_image: @config.tabBar?.backgroundImage ? ""
    tab_bar_tint_color: @config.tabBar?.tintColor ? ""
    tab_bar_button_title_text_color: @config.tabBar?.tabTitleColor ? ""
    tab_bar_button_title_shadow_color: @config.tabBar?.tabTitleShadowColor ? ""
    tab_bar_selected_icon_tint_color: @config.tabBar?.selectedTabTintColor ? ""
    tab_bar_selected_indicator_background_image: @config.tabBar?.selectedTabBackgroundImage ? ""
    loading_screen_color: @config.loadingScreen?.tintColor ? ""
    wait_for_document_ready_before_open: @config.wait_for_document_ready_before_open ? "true"
    open_clicked_links_in_new_layer: @config.open_clicked_links_in_new_layer ? "false"
    shake_gesture_enabled_during_development: @config.shake_gesture_enabled_during_development ? "false"
    tabs: @tabsCloudSchemaRepresentation()
    copy_to_user_files: @userFilesObject(@config)
    hosts: []

  tabsCloudSchemaRepresentation: =>
    @configurator.eitherSupersonicOrLegacy().fold(
      =>
        tabs = []

        if @config.structure.tabs?
          for configTab, i in @config.structure.tabs
            tab =
              title: configTab.title
              id: configTab.id
              icon: configTab.icon || "dolan.png"
              location: routingHelpers.parseLocation(configTab.location)
            tabs.push tab

        tabs
      =>
        tabs = []

        if @config.tabBar?.tabs?
          for configTab, i in @config.tabBar.tabs
            tab =
              title: configTab.title
              id: configTab.id
              icon: configTab.icon || "dolan.png"
              location: configTab.location
            tabs.push tab

        tabs
    )

  statusBarStyle: =>
    unless @config.statusBar?.enabled? && @config.statusBar.enabled == true
      "hidden"
    else
      @config.statusBar.style

  userFilesObject: (config)->
    userFilesObject = []

    for file in config.copyToUserFiles
      userFilesObject.push file

    return userFilesObject

  projectName: =>
    @configurator.eitherSupersonicOrLegacy().fold(
      =>
        @config.app.name
      =>
        @config.name
    )

module.exports = DeployConverter
