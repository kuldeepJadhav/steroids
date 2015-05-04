request = require "request"

Login = require "./Login"

run= (params) ->
  new Promise (resolve, reject) ->
    request(params, (err, res, data) ->
      if err?
        reject err
      else if res.statusCode == 200 or res.statusCode == 201
        resolve data
      else
        reject new Error "Failed with unknown error"
    )

runAuthenticated = (method, url) ->
  run(
    auth:
      user: Login.currentAccessToken()
      password: "X"
    method: method
    url: url
  )

module.exports = http = {
  request: run
  requestAuthenticated: runAuthenticated
}
