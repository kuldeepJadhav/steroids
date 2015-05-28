path = require 'path'
fs = require 'fs'

module.exports = oauthTokenPath = path.join(
  (process.env.HOME || process.env.USERPROFILE)
  '.appgyver'
  'devgyver.token.json'
)

if !fs.existsSync oauthTokenPath
  console.log """
    Cannot run tests with oauthTokenPath set to #{oauthTokenPath}:
    Path does not exist.
  """
  process.exit -1

try
  JSON.parse fs.readFileSync oauthTokenPath
catch e
  console.log """
    Cannot run tests with oauthTokenPath set to #{oauthTokenPath}:
    '#{e.message}'
    Contents do not appear to be well-formed JSON.
  """
  process.exit -1
