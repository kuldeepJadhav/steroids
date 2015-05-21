path = require "path"
util = require "util"
fs = require "fs"
OAuth2 = require('oauth').OAuth2

paths = require "./paths"
Help = require "./Help"

class Login

  @authTokenExists: ()->
    fs.existsSync paths.oauthTokenPath

  @removeAuthToken: ()->
    if @authTokenExists
      fs.unlinkSync paths.oauthTokenPath

  @currentToken: () ->
    token = if @authTokenExists()
      tokenJSON = fs.readFileSync paths.oauthTokenPath, 'utf8'
      token = JSON.parse tokenJSON
    else
      null

    return token

  @currentAccessToken: ()->
    token = @currentToken()

    return token?.access_token || steroidsCli.options.argv.accessToken

  constructor: (@options={})->
    @settings =
      clientId:      steroidsCli.options.argv.authID || "3ceba0084a474f1502c20ef05e0489546a1f89c1b5fb0e7e6666e720c7977c96"
      clientSecret:  steroidsCli.options.argv.authSecret || "f635ef74e2c759134f968d801a35e075f8a9c250292f1793e22141827d327777"
      baseUrl:       steroidsCli.options.argv.authURL || "https://accounts.appgyver.com"
      authPath:      "/auth/appgyver_id/authorize"
      tokenPath:     "/auth/appgyver_id/access_token"
      userPath:      "/auth/appgyver_id/user.json"
      responseType:  "code"

    @oauth = new OAuth2(
      @settings.clientId, @settings.clientSecret,
      @settings.baseUrl,
      @settings.authPath,
      @settings.tokenPath)

  run: =>
    Updater = require "./Updater"
    updater = new Updater
    updater.check
      from: "login"

    return new Promise (resolve, reject) =>
      @loginPromise =
        resolve: resolve
        reject: reject

      Server = require "./Server"

      @options.server = Server.start
        port: @options.port
        callback: ()=>
          @authorize()

  authorize: ()->
    @startServer()

    redirectUrl = "http://127.0.0.1:#{@options.port}/__appgyver/login/callback"
    authUrl = "#{@settings.baseUrl}#{@settings.authPath}?response_type=#{@settings.responseType}&client_id=#{@settings.clientId}&redirect_uri=#{encodeURIComponent(redirectUrl)}"

    open = require("open")
    util.log "Opening authentication URL in the browser: #{authUrl}"

    open(authUrl)

  startServer: ()->
    LoginServer = require "./servers/LoginServer"
    @server = new LoginServer
      path: "/"
      loginHandler: this

    @options.server.mount(@server)

  consumeAuthorizationCode: (authCode) =>
    @oauth.getOAuthAccessToken(authCode, {}, @consumeAccessToken)

  consumeAccessToken: (somethingNull, accessToken, refreshToken, options) =>
    options.access_token = accessToken
    options.refresh_token = refreshToken
    options.received_at = Math.round(new Date().getTime() / 1000)

    if not fs.existsSync path.dirname(paths.oauthTokenPath)
      fs.mkdirSync path.dirname(paths.oauthTokenPath)

    fs.writeFileSync paths.oauthTokenPath, JSON.stringify(options)

    @loginPromise.resolve()

module.exports = Login
