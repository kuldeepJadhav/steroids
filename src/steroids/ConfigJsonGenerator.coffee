fs = require "fs"

paths = require "./paths"
Config = require "./project/config"

module.exports = class ConfigJsonGenerator

  constructor: ->

  writeConfigJson: ->
    config = new Config()
    currentConfig = config.getCurrent()

    json = @constructConfigJson(currentConfig)

    if json?
      fs.writeFileSync paths.application.dist.configJson, JSON.stringify(json, null, 2) # prettify with 2 spaces

  constructConfigJson: (config)->
    unless config.addons?
      return null

    result = { features: {} }
    for addon, addonConfig of config.addons
      for key, value of addonConfig
        {feature, legacyKey, legacyValue} = @getLegacyProperty(addon, key, value)
        if feature? # LEGACY
          result.features[feature] ||= {}
          result.features[feature][legacyKey] = legacyValue
        else # FUTURE
          result.features[addon] ||= {}
          result.features[addon][key] = value

    return result


  getLegacyProperty: (addon, key, value)->
    return switch addon
      when "facebook"
        switch key
          when "enabled"
            feature: "http://appgyver.com/steroids/addons/facebook"
            legacyKey: "enabled"
            legacyValue: if value then "true" else "false"
      when "geolocation"
        switch key
          when "continuousUpdates"
            feature: "http://appgyver.com/steroids/addons/geolocation"
            legacyKey: "continuousUpdates"
            legacyValue: if value then "true" else "false"
      when "oauthio"
        switch key
          when "publicKey"
            feature: "http://appgyver.com/steroids/addons/oauthio"
            legacyKey: "publicKey"
            legacyValue: value
      when "urbanairship"
        switch key
          when "enabled"
            feature: "http://appgyver.com/steroids/addons/urbanairship"
            legacyKey: "enabled"
            legacyValue: if value then "true" else "false"
      else
        feature: null
        legacyKey: null
        legacyValue: null
