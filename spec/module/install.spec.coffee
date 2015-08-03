require('chai').should()

steroids = require('./steroids')()

skipWhen process.env.STEROIDS_TEST_RUN_MODE, "fast"

describe "module", ->
  describe "install", ->
    it "is mentioned in the help string", ->
      steroids.module.help().check ({stdout}) ->
        stdout.should.match /module install/

    it "fails without a module name argument", ->
      steroids.module.install().check ({stderr}) ->
        stderr.should.match /name required/

    it "fails for a non-existing module", ->
      steroids.module.install("dsfargeg").check ({stderr}) ->
        stderr.should.match /not published/

    describe "with a valid module name as target", ->
      it "runs successfully", ->
        steroids.module.install("com.appgyver.install-test").check ({stdout, stderr}) ->
          stderr.should.be.empty
          stdout.should.match /installation complete/i
          stdout.should.match /com\.appgyver\.install-test/

      it "creates a root directory for modules", ->
        steroids.file("composer_modules").exists().should.be.true

      it "creates a directory for the installed module", ->
        steroids.file("composer_modules", "com.appgyver.install-test").exists().should.be.true

      it "extracts module files from zip to directory", ->
        steroids.file("composer_modules", "com.appgyver.install-test", "index.html").exists().should.be.true

      it "creates module definition file for current project", ->
        steroids.file("config", "module.json").exists().should.be.true

      it "adds target module to module dependency list", ->
        steroids.file("config", "module.json")
          .readJson()
          .should.have
          .property("dependencies")
          .property("com.appgyver.install-test")
          .be.defined
