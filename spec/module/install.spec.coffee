require('chai').should()

steroids = require('./steroids')()

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->
  describe "install", ->
    it "is mentioned in the help string", ->
      steroids.module.help().check ({stdout}) ->
        stdout.should.match /module install/

    it "fails without a module name argument", ->
      steroids.module.install().check ({stdout}) ->
        stdout.should.match /name required/

    describe "with a valid module name as target", ->
      xit "runs successfully", ->
        steroids.module.install("com.appgyver.comments").check ({code, stdout}) ->
          code.should.equal 0
          stdout.should.match /Installing/
