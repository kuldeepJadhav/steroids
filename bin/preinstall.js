// Prevent script from running in non-interactive environments
if (process.env.STEROIDS_TEST_RUN_ENVIRONMENT == "travis") {
  console.log("in travis, exit with: 0");
  process.exit(0);
}
if (!process.stdout.isTTY) {
  console.log("installing steroids in a non-interactive shell, skipping preinstall checks");
  process.exit(0);
}

var cp = require("child_process"),
    exec = cp.exec,
    path = require("path"),
    fs   = require("fs"),
    util = require("util"),
    sys = require("sys");

var askConfirm = function() {
  process.stdin.setRawMode( true );
  process.stdin.resume();
  process.stdin.setEncoding('utf8');

  process.stdin.on('data', function(key){
    if (key === '\r' || key == 'y') {
      process.exit(0);
    } else {
      process.exit(1);
    }
  });
}

var tryAndRun = function(cmd, success, failure, done) {
  exec(cmd, function(err, stdout, stderr) {
    if (err) {
      failure(err, stderr);
    } else {
      success(stdout, stderr);
    }
    if (done !== undefined) {
      done(success);
    }
  });
};

var found = function(dependency) {
  return function() {
    console.log("  Found " + dependency + ", good.");
  };
};

var notFound = function(dependency, instructions) {
  return function() {
    console.log("  ERROR: " + dependency + " not found.");
    if (instructions !== undefined) {
      console.log("");
      for (var i in instructions) {
        console.log("  " + instructions[i]);
      }
    }

    setTimeout(function() {
      console.log("\n\nCheck failed - required components missing!");

      process.stdout.write("Do you still want to continue, we might have not detected everything correctly (y/N): ");
      askConfirm();
    }, 500);

  };
};

var pleaseInstall = function(dependency) {
  return ["Please install " + dependency + " and run this installer again."];
};

var checkNPMOwnership = function(done) {

  var home = process.env['HOME'];
  exists = fs.existsSync(path.resolve(home, ".npm"));

  // Check if .npm exists, if not - assume fresh install and precede
  if (!exists) {
    return;
  }

  var currentUser = process.env['USER'];

  process.stdout.write("Checking $HOME/.npm ownership, making sure that '"+currentUser+"' owns everything ...");

  var cmdToFindFilesNotOwnedByUser = 'find "$HOME/.npm" \! -user "$USER" -print';

  cp.exec(cmdToFindFilesNotOwnedByUser, function(error, stdout, stderr) {
    if (error) {
      console.log("Error when running command: " + cmdToFindFilesNotOwnedByUser);
      console.log("The error was:\n");
      console.log(stderr);

      console.log("\nDo you want to continue anyway? (y/N)");
      askConfirm();
      return;
    }

    if (stdout == "") {
      console.log(" OK");
    } else {
      console.log(" Error\n");
      console.log("And it's good that we did this check, because these files:\n");
      console.log(stdout);
      console.log("\nare not owned by '"+currentUser+"', this will cause problems.");
      console.log("Fix this with:\n\n\t$ sudo chown -R "+currentUser+" $HOME/.npm\n\n");
      console.log("We recommend that you abort installation now and run this command to change ownership of those files to your user account.");
      console.log("\nDo not use sudo with node commands. Do you really want to ignore these words of wisdom and continue anyway? (y/N)");
      askConfirm();
    }
    done();

  })

}

var checkNPMWriteable = function(done) {

  var currentUser = process.env['USER'];
  process.stdout.write("Checking $HOME/.npm write acess, making sure that '"+currentUser+"' has write access ...");

  var cmd = "find $HOME/.npm \! -perm -200 -print"; // Find all files without write permissions

  cp.exec(cmd, function(error, stdout, stderr) {
    if (error) {
      console.log("Error when running command: " + cmd);
      console.log("The error was:\n");
      console.log(stderr);

      console.log("\nDo you want to continue anyway? (y/N)");
      askConfirm();
      return;
    }

    if (stdout == "") {
      console.log(" OK");
    } else {
      console.log(" Error!\n\n");
      console.log("The following files are not writeable by '"+currentUser+"', this will cause problems.\n");
      console.log(stdout);
      console.log("This was probably caused by running Node/NPM with sudo, which is not recommended.")
      console.log("Fix this with:\n\n\t$ sudo chmod -R u+w $HOME/.npm\n");
      console.log("We recommend that you abort installation now and run this command to change write permission of those files to your user account.");
      console.log("\n\nDo you really want to ignore these words of wisdom and continue anyway? (y/N)");
      askConfirm();
    }
    done();
  })
}

var checkComponents = function() {

  process.stdout.write("Checking for compatibility with Node.js version " + process.version + " ...");

  if(/^v0\.10/.test(process.version)) {
    console.log(" OK\n");
  } else {
    console.log("");
    var errorBanner = fs.readFileSync(path.join(__dirname, "..", "support", "error-nocolors")).toString();
    console.log(errorBanner);

    console.log("\nIn version 3.5.11, Steroids was updated to work on Node.js version 0.10.x only. You are currently using Node.js " + process.version + ".");
    console.log("\nIf you have NVM installed, you can use the '$ nvm install 0.10' command to install Node.js 0.10.x, and '$ nvm alias default 0.10' to make it your default Node.js version.");
    console.log("\nSee the installation instructions at https://academy.appgyver.com/installwizard for more information.");
    console.log("\nNOTE: After you have updated your Node.js version (check with '$ node -v'), you need to write '$ npm install steroids -g' (instead of 'npm update') to update Steroids npm.")
    console.log("\n\nDo you really want to ignore these words of wisdom and continue anyway? (y/N)");
    askConfirm();
    return;
  }

  console.log("Checking for required components ...\n");

  if (process.platform === "win32") {

    tryAndRun("git --version",
      found('git'),
      notFound("command 'git'", pleaseInstall("git")),
      function() {
        console.log("\nDependencies looks good! Starting Steroids installation...\n");
      }
    );

  } else if (process.platform === "darwin") {

    // Git and check file permisson
    tryAndRun("git --version",
      found('git'),
      notFound("git", [
        "For Git installation, we recommend using homebrew, see http://mxcl.github.com/homebrew/",
        "Once homebrew is installed, install git with: brew install git",
        "Run this installer again once you have git installed."
      ]),
      function() {
        console.log("\nDependencies ... OK\n");
        checkNPMOwnership( function() {
          checkNPMWriteable( function() {
            console.log("\nDependencies and permissions looks good! Starting Steroids installation...\n");
          });
        });
      }
    );

  } else {
    // Require gcc, make and git
    tryAndRun("gcc -v",
      found("gcc"),
      notFound("gcc", pleaseInstall("gcc")),
      function() {
        tryAndRun("make -v",
          found("make"),
          notFound("make", pleaseInstall("make")),
          function() {
            tryAndRun("git --version",
              found("git"),
              notFound("git", pleaseInstall("git")),
              function() {
                console.log("\nDependencies ... OK\n");
                checkNPMOwnership( function() {
                  checkNPMWriteable( function() {
                    console.log("\nDependencies and permissions looks good! Starting Steroids installation...\n");
                  });
                });
              }
            );
          }
        );
      }
    );
  }
}

var packageJSON = require("../package.json");
steroidsVersion = packageJSON.version;

console.log("\n\n\nAppGyver Steroids² "+steroidsVersion+" installation\n");

console.log("If you have any problems, please visit our forums at http://community.appgyver.com\n\
We are now trying to detect required dependencies and problems.\n\
Some dependencies (like dtrace-provider) will print ugly warnings to the screen, but everything should be fine.\n \
\n \
 - The AppGyver team\n \
\n \
\nStarting installation in ...");

var printMessages = function(messages, whenDone) {
  if ( messages.length == 0 ) {
    console.log("\n");
    whenDone();
    return;
  }
  var first = messages.splice(0, 1)[0];
  console.log(first)

  setTimeout(function() {
    printMessages(messages, whenDone)
  }, 1000);
}
printMessages(["3","2","1", "Lift-off!"], checkComponents)
