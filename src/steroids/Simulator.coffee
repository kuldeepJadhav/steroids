steroidsSimulators = require "steroids-ios-packages"
spawn = require("child_process").spawn

sbawn = require "./sbawn"
Help = require "./Help"

os = require "os"
paths = require "./paths"

class Simulator

  running: false

  NotInstalled: class NotInstalled extends steroidsCli.SteroidsError
  UnsupportedVersion: class UnsupportedVersion extends steroidsCli.SteroidsError

  constructor: (@options = {}) ->

  xCodeInstalled: ->
    new Promise (resolve, reject) ->
      xcodeSession = sbawn
        cmd: "pkgutil"
        args: ["--pkgs=com.apple.pkg.Xcode.*"]
        exitOnError: false

      xcodeSession.on "exit", ->
        if xcodeSession.stdout.match 'com.apple.pkg.Xcode'
          resolve()
        else
          reject new NotInstalled "XCode not installed."

  validXCodeVersion: ->
    new Promise (resolve, reject) ->
      minimumXcodeVersion = /Xcode 6./

      xcodeVersionSession = sbawn
        cmd: "xcodebuild"
        args: ["-version"]

      xcodeVersionSession.on "exit", ->
        valid = xcodeVersionSession.stdout.match(minimumXcodeVersion)
        if valid
          resolve()
        else
          reject new UnsupportedVersion "Please update to XCode 6 to run the simulator."

  getDevicesAndSDKs: () =>
    new Promise (resolve, reject) =>
      unless steroidsCli.host.os.isOSX()
        reject new UnsupportedVersion "Simulator only supported in OS X"
        return
      @xCodeInstalled()
        .then(@validXCodeVersion)
        .then ->
          showDevicesSession = sbawn
            cmd: paths.iosSim.path
            args: ["showdevicetypes"]

          showDevicesSession.on "exit", =>
            [deviceRows..., crap] = showDevicesSession.stdout.split("\n")
            devices = []
            for deviceRow in deviceRows
              [device, sdks] = deviceRow.split(",")
              devices.push
                name: device
                sdks: sdks

            resolve(devices)
        .catch (error) =>
          reject error

  run: (opts={}) =>
    new Promise (resolve, reject) =>
      unless steroidsCli.host.os.isOSX()
        reject new UnsupportedVersion "Simulator only supported in OS X"
        return
      @xCodeInstalled()
        .then(@validXCodeVersion)
        .then =>
          @stop()
          @running = true

          cmd = paths.iosSim.path
          args = ["launch", steroidsSimulators.latestSimulatorPath]

          device = "iPhone-6"
          iOSVersion = undefined

          if opts.device?
            # Split into device type and optional, '@'-separated suffix specifying the iOS version (SDK version; e.g., '5.1').
            [device, iOSVersion] = opts.device.split('@')

          steroidsCli.log "Starting #{device} Simulator X3"
          deviceArg = "com.apple.CoreSimulator.SimDeviceType.#{device}"

          if iOSVersion?
            deviceArg = deviceArg + " ,#{iOSVersion}"

          args.push "--devicetypeid", deviceArg
          args.push "--verbose" if steroidsCli.debugEnabled

          @killall().then( =>
            steroidsCli.debug "Spawning #{cmd}"
            steroidsCli.debug "with params: #{args}"

            @simulatorSession = sbawn
              cmd: cmd
              args: args
              stdout: steroidsCli.debugEnabled?
              stderr: true

            @simulatorSession.on "exit", () =>
              @running = false

              steroidsCli.debug "Killing iOS Simulator ..."

              @killall()

              unless ( @simulatorSession.stderr.indexOf('Session could not be started') == 0 )
                resolve()
                return

              Help.attention()
              Help.resetiOSSim()

              setTimeout () =>
                resetSimulator = sbawn
                  cmd: steroidsSimulators.iosSimPath
                  args: ["start"]
                  debug: true
              , 250
          )
          resolve()

        .catch(NotInstalled, UnsupportedVersion, (error) =>
          reject error
        )

  stop: () =>
    @simulatorSession.kill() if @simulatorSession

  killall: () ->
    new Promise (resolve) ->
      if steroidsCli.host.os.isOSX()
        killSimulator = sbawn
          cmd: "/usr/bin/pkill"
          args: ["-9", "imulator"]

        killSimulator.on "exit", () ->
          steroidsCli.debug "Killed iOS Simulator."
          resolve()
      else
        resolve()

module.exports = Simulator
