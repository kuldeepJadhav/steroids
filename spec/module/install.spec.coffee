require('chai').should()

steroids = require('./steroids')()

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->
  describe "install", ->
    it "runs successfully", ->
      steroids.module.install("com.appgyver.comments").check ({code, stdout}) ->
        code.should.equal 0
        stdout.should.match /Installing/
