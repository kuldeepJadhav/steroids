require('../src/steroids').setupSteroidsGlobal()
Login = require '../src/steroids/Login'

module.exports = ensureLoggedIn = ->
  if !Login.authTokenExists()
    if !process.env.STEROIDS_DEVGYVER_ACCESS_TOKEN?
      throw new Error """
        Access token required for test runs.
        Please set STEROIDS_DEVGYVER_ACCESS_TOKEN in your environment.
      """

    login = new Login
    login.consumeAccessToken(
      null
      process.env.STEROIDS_DEVGYVER_ACCESS_TOKEN
      null
      {}
    )

    if !Login.authTokenExists()
      throw new Error """
        Access token could not be written to token storage.
      """
