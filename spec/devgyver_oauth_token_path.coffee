path = require 'path'

module.exports = oauthTokenPath = path.join(
  (process.env.HOME || process.env.USERPROFILE)
  '.appgyver'
  'devgyver.token.json'
)
