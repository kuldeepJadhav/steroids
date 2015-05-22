request = require "request"

Login = require "./Login"

run = (params) ->
  new Promise (resolve, reject) ->
    request(params, (err, res, data) ->
      if err?
        reject err
      else if res.statusCode == 200 or res.statusCode == 201
        resolve data
      else if res.statusCode >= 400 and res.statusCode < 500 and params.auth
        reject new Error """
          HTTP status '#{res.statusCode}', url '#{res.request.uri.href}'
          This endpoint requires authentication. Have you logged in with `steroids login`?
        """
      else
        reject new Error "Failed with unknown error, HTTP status '#{res.statusCode}', url '#{res.request.uri.href}'"
    )

runAuthenticated = (params = {}) ->
  params.auth =
    user: Login.currentAccessToken()
    password: "X"

  run params

module.exports = http = {
  request: run
  requestAuthenticated: runAuthenticated
}
