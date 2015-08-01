## 4.1.14 (TODO)
- Updated the tabBar configuration obj to support the navigationBar and
hidesNavigationBar parameters.
Now you can define a tab webview and the Navigation bar parameters at the same
time.

## 4.1.13 (2015-07-31)

Changes:
- Updated iOS Simulator to use v4.0.4 of AppGyver Wrapper.

## 4.1.12 (2015-07-23)

Changes:
- Speed up install by fetching Steroids binary assets (e.g. bundled simulators) via CloudFront instead of directly from S3.

## 4.1.11 (2015-07-16)

Features:
- Updated `steroids-connect` dependency to v1.0.34, with updates to the data browser.

Changes:
- Remove Node.js version check from preinstall script.

Bugfixes:
- Trying to log out without a session gives a proper error message.

## 4.1.10 (2015-06-23)

Changes:
- Updated Android Emulator to use v4.0.6 of AppGyver Wrapper.

Features:
- `steroids connect` supports an optional `--simulate` flag to launch the iOS simulator immediately

Fixes:
- `rootView` in `structure.coffee` may now be a route
- Route paths for views match Supersonic by also allowing query parameters
- Adding a `--watch` argument to `steroids connect` does not prevent livereload
- Add missing configuration.extra_response_headers to cloud app package. Closes [#902](https://github.com/AppGyver/steroids/issues/902).

## 4.1.9 (2015-06-16)
Changes:
- Updated Android Emulator to use v4.0.5 of AppGyver Wrapper.

Fixes:
 - Add missing `configuration.extra_response_headers` to cloud app package. Closes [#902](https://github.com/AppGyver/steroids/issues/902).

## 4.1.8 (2015-06-08)
Changes:
- Update `generator-steroids` version to latest


## 4.1.7 (2015-06-02)

Changes:
- `steroids module deploy` accepts an optional `--deploymentJsonPath` argument

Fixes:
- Add missing module import preventing `steroids module deploy` from running

## 4.1.6 (2015-06-01)

Changes:
- Improve instructions output by `steroids module` commands

## 4.1.5 (2015-05-29)

Fixes:
- iOS Simulator no longer takes up 200+% CPU. Closes [#761](https://github.com/AppGyver/steroids/issues/761).

Changes:
- Add creation of a Composer 2 module as an option in `steroids create`
- Add usage instructions for `steroids module`

## 4.1.4 (2015-05-22)

Changes:
- `steroids module deploy` announces the deployment location after success

Fixes:
- Add missing module import preventing `steroids module deploy` from running

## 4.1.3 (2015-05-22)

Features:
- `steroids module deploy` deploys an AppGyver Enterprise module to the AppGyver Cloud

Fixes:
- Uncaught errors properly result in a non-zero exit code for the process in the terminal

## 4.1.2 (2015-05-18)

Changes:
- Rename Steroids Enterprise configuration file `module.json` to `appgyver.json`

## 4.1.1 (2015-05-13)

Features:
- `steroids connect --gruntTask=<task>` lets you use a different task than the default one during project make. The custom task must be defined in the project's Gruntfile.
- `steroids module create` creates an AppGyver Enterprise module development harness

Changes:
- `steroids module init` requires `--user-id`

## 4.1.0 (2015-05-07)

Features:
- `steroids module init` initializes an AppGyver Enterprise module config
- `steroids module refresh` reloads the module environment for an AppGyver
  Enterprise application.


## 4.0.15 (2015-04-01)

Skip preinstall checks in non-interactive shell environments, eg. Travis-CI and Heroku.

## 4.0.14 (2015-04-01)

Allow `steroids deploy` to accept a `--builder` parameter to distinguish deployments of user-built apps from deployments of apps built with AppGyver platform services.

## 4.0.13 (2015-03-24)

Fix a bug that prevented the `steroids emulate` command from being used on Linux.

## 4.0.12 (2015-03-02)

Update `request`, `winston`, `xmlbuilder` and `chokidar` dependencies to latest versions to get rid of installation warnings and errors.

## 4.0.11 (2015-02-11)

Fix preinstall script on Windows harder.

## 4.0.10 (2015-02-11)

Fix preinstall script on Windows.

## 4.0.9 (2015-02-11)

Bugfixes and friendlier error messages.

Features:
- If application config files are erroneous, print a friendlier error message. Closes [#80](https://github.com/appgyver/steroids/issues/80).

Bugfixes:
- Fixed a bug where the Steroids preinstall script would fail on certain Linux distros that have a `nodejs` instead of a `node` executable.
- Fixed an issue on Mac when Lo has multiple addresses. Thanks to @mikey0000 for the PR!

## 4.0.8 (2015-01-23)

Changes:
- Updated Android simulator to 4.0.4
- Updated iOS simulator to 4.0.3

Bugfixes:
 - Fixed a bug where a missing `<content>` tag caused Cordova project builds to error out.
 - Fixed a bug where Bower components from the Steroids Connect screen were overriding app files in LiveReload mode. Closes [#746](https://github.com/AppGyver/steroids/issues/746).

## 4.0.7 (2014-12-23)

4.0.6 rollback reverted, Windows bug detailed in 4.0.6 changelog fixed. `steroids connect` now works in Cordova projects, see 4.0.5 changelog below for details.

## 4.0.6 (2014-12-22)

Rollbacking 4.0.5 changes due to a bug discovered in Windows 7 that causes the Steroids Development Server to not show up. A fix will be provided with 4.0.7 ASAP.

## 4.0.5 (2014-12-22)

Experimental: run `steroids connect` in Cordova projects to test, develop and share your Cordova apps with Steroids Tooling.

Experimental features:
 - You can now run `steroids connect` in Cordova projects. The project files will not be changed – the `dist/` folder is created in a system temp folder. The initial location will be read from the `<content src="index.html">` tag in `config.xml`.
 - You can now run `steroids deploy` in Cordova projects. The first time you deploy, you must allow Steroids CLI to create a `config/cloud.json` file for you by running `steroids deploy --allowConfigCreation`. Note that any plugins will need to be re-included in the Build Service.

## 4.0.4 (2014-12-19)

Features:
 - Updated iOS Simulator to v4.0.2.

Bugfixes:
 - `steroids-connect` updated to v1.0.31, fixing an issue with data scaffold generator only generating a scaffold for the first of your resources. Closes [#699](https://github.com/AppGyver/steroids/issues/699).
 - Preinstall script no longer fails if there are spaces in your disk volume name.
 - Fixed Genymotion Emulator paths on Linux.

## 4.0.3 (2014-12-11)

Features:
 - Android emulator updated to v4.0.3.

Bugfixes:
 - Fixed an error when running cloud deploy via the Connect Screen.
 - Fixed an error when Updater was run without Internet connectivity.
 - Connect Screen now shows logs for legacy Steroids project too (compatible with `steroids.logger.log`)


## 4.0.2 (2014-12-05)

Bugfixes:
 - Data Scaffold generator in Connect Screen now generates JavaScript scaffold correctly.

## 4.0.1 (2014-12-04)

Fixes a bug where support for the `statusBar` config for iOS was missing from Supersonic projects.

## 4.0.0 (2014-12-03) – Steroids² CLI

With the Supersonic framework launch, we have redesigned the Steroids tooling with many new features, improvements and bugfixes.

Presenting Steroids² CLI. For full usage of the new commands, run `steroids usage` in terminal.

New feature highlights:
- Huge speed improvements
- Completely redesigned Connect Screen. Closes [#49](https://github.com/AppGyver/steroids/issues/49), [#52](https://github.com/AppGyver/steroids/issues/52), [#68](https://github.com/AppGyver/steroids/issues/68)
  - Show list of connected devices
  - Improved iOS Simulator. Closes [#56](https://github.com/AppGyver/steroids/issues/56), [#60](https://github.com/AppGyver/steroids/issues/60), [#326](https://github.com/AppGyver/steroids/issues/326), [#151](https://github.com/AppGyver/steroids/issues/151) and [#57](https://github.com/AppGyver/steroids/issues/57)
  - Open iOS Simulator or Android emulator from connect window. Closes [#53](https://github.com/AppGyver/steroids/issues/53).
  - Logs in connect window. Closes [#50](https://github.com/AppGyver/steroids/issues/50).
  - Initializing and managing Data from the connect window
  - ...and much much more
- Improved file watcher, now enabled by default. Closes [#44](https://github.com/AppGyver/steroids/issues/44) and [#287](https://github.com/AppGyver/steroids/issues/287).
- `steroids create` now creates Supersonic projects. Closes [#108](https://github.com/AppGyver/steroids/issues/108).
  - Possibility to create a project with CoffeeScript instead of JavaScript. Closes [#152](https://github.com/AppGyver/steroids/issues/152).
- Android emulator (experimental). Closes [#398](https://github.com/AppGyver/steroids/issues/398).
- LiveReload support to update changes without requiring the app to reload itself. Enable by running `steroids connect --livereload`. Experimental.
- Improved Bower dependency management. Closes [#62](https://github.com/AppGyver/steroids/issues/62).
- Improved `steroids update`. Closes [#78](https://github.com/AppGyver/steroids/issues/78).
- Redesigned default Grunt tasks. Closes [#69](https://github.com/AppGyver/steroids/issues/69) and [#222](https://github.com/AppGyver/steroids/issues/222).

Also, following minor bugfixes/deprecations are in place:
- Keyboard config settings removed due to incompability with new keyboard plugin. Closes [#101](https://github.com/AppGyver/steroids/issues/101).
- `steroids serve` was removed due to the way the new CLI works, closes [#294](https://github.com/AppGyver/steroids/issues/294).
- `preMake` and `postMake` hooks deprecated, closes [#45](https://github.com/AppGyver/steroids/issues/45) and [#51](https://github.com/AppGyver/steroids/issues/51).
- Improved preinstall script. Closes [#59](https://github.com/AppGyver/steroids/issues/59).
- Weinre removed. Closes [#310](https://github.com/AppGyver/steroids/issues/310).

### 3.9.1 (2014-11-05)
Bugfixes:
- `steroids create` no longer runs bower from steroids-generator, that caused error if Bower was not globabally installed.

Features:
- `steroids create` produces less output and timeouts if npm install or bower install goes stale.

## 3.9.0 (2014-11-03)

Secret changelog started. This 3.9.0 will be replaced with 4.0.0 release notes steroids^2 goes out.

## 3.5.17 (2014-11-07)

Features:
- Updated Steroids generators to [v0.4.5](https://github.com/AppGyver/generator-steroids/blob/master/CHANGELOG.md#045-2014-11-05)
- Steroids simulator updated to iOS Native Runtime v4.0.1

## 3.5.16 (2014-10-29)

Features:
- Updated Steroids generators to [v0.4.4](https://github.com/AppGyver/generator-steroids/blob/master/CHANGELOG.md#044-2014-10-29).

Bugfixes:
- The update checker (the one that checks that your CLI and Scanner are updated to the latest version, and gives you a notice if you need to update) no longer crashes CLI in the case the backend doesn't give a proper response. Closes [#584](https://github.com/AppGyver/steroids/issues/584).

## 3.5.15 (2014-10-17)

Bugfixes:
- `steroids connect` no longer gives an erroneous warning about an outdated CLI version when a new device connects. Closes [#569](https://github.com/AppGyver/steroids/issues/569).
- When checking if a new Scanner version is available, `steroids connect` no longer mixes up version numbers between clients. Closes [#456](https://github.com/AppGyver/steroids/issues/456).
- When connecting with an out-of-date Scanner, `steroids connect` no longer spam the output full of "Please update" messages. Closes [#562](https://github.com/AppGyver/steroids/issues/562).

## 3.5.14 (2014-10-15)

Features:
- Add id for Tab Items so they can be referred to with Native CSS using #tab-id.
- Deploy attribute `steroids.config.copyToUserFiles` to the Cloud.

## 3.5.13 (2014-10-10)

Steroids Simulator updated to iOS v4.0.0 and generator to v0.4.3 which includes native UI styling with Pixate CSS.

## 3.5.12 (2014-09-29)

Fixed a bug where Steroids CLI would not kill the iOS Simulator process between subsequent uses of the `simulator` command, leading to errors.

## 3.5.11 (2014-09-24)

Xcode 6 Simulator types supported. Remove mention of Node.js v0.11 compatibility due to errors being raised by submodules. Supported Node.js version is now 0.10.

Features:
- Support new iOS Simulator types in Xcode 6:
  - iPhone 4S (`steroids simulator --deviceType=iphone_4s`)
  - iPhone 5 (`steroids simulator --deviceType=iphone_5`)
  - iPhone 5S (`steroids simulator --deviceType=iphone_5s`)
  - iPhone 6 (`steroids simulator --deviceType=iphone_6`)
  - iPhone 6 Plus (`steroids simulator --deviceType=iphone_6_plus`)
  - iPad 2 (`steroids simulator --deviceType=ipad_2`)
  - iPad Retina (`steroids simulator --deviceType=ipad_retina`)
  - iPad Air (`steroids simulator --deviceType=ipad_air`)

Changes:
- No longer support Node.js v0.11.
- Old Xcode 5 Simulator types remain available as legacy commands, but dropped from usage:
  - `steroids simulator --deviceType=ipad`
  - `steroids simulator --deviceType=ipad_retina`
  - `steroids simulator --deviceType=iphone_retina_3_5_inch`
  - `steroids simulator --deviceType=iphone_retina_4_inch`

Bugfixes:
- Remove unused `node-sass` dependency

## 3.5.10 (2014-09-22)

Hotfix patch fixed previous release
- Use fork of ios-sim instead of upstream to get prebuilt binary along

## 3.5.9 (2014-09-22)

Fixed iOS Simulator to work with Xcode 6 and updated the iOS Simulator runtime to v3.5.2.

Changes:
- Use the [`ios-sim`](https://github.com/phonegap/ios-sim) npm package instead of AppGyver's fork.
- `ios-sim` version updated to 2.0.1, fixing a bug where the iOS Simulator would not start with Xcode 6 installed. Closes [#517](https://github.com/AppGyver/steroids/issues/517).


## 3.5.8 (2014-08-29)

Steroids Data bugfixes.

Changes:
- Updated `generator-steroids` dependency to v0.4.2.

## 3.5.7 (2014-08-29)

Updated generated examples.

Features:
- Updated generated examples to run with latest version of the iOS native runtime and Steroids.js.

Secret features:
- Initial support for Steroids Data.

## 3.5.6 (2014-08-22)

Updated iOS Simulator runtime.

## 3.5.5 (2014-07-18)

Changes:
- Internal, non-breaking changes to the "list of files to be copied to the User Files directory" feature introduced in v3.5.4.

## 3.5.4 (2014-07-15)

Features:
- In `config/application.coffee`, you can now define a list of files that will be copied to the [User Files directory](https://academy.appgyver.com/categories/4-app-architecture/contents/43-app-structure-on-the-device).

## 3.5.0 - 3.5.3 (2014-07-14)

Updated iOS Simulator runtime, updated dependencies.

Changes:
- Updated `generator-steroids` npm dependency to v0.3.10
- Updated `bower` npm dependency to to v1.3.8
- Updated iOS Simulator runtime to v3.5.0

## 3.1.28 (2014-06-04)

Updated iOS Simulator runtime, Simulator bugfixes.

Features:
- iOS Simulator runtime updated to [v3.1.6-p4](https://github.com/AppGyver/scanner/blob/master/changelog-ios-patch-edge.md#316-p3-2014-06-03).

Bugfixes:
- Bettered the fix for the iOS Simulator starting with black screen.

## 3.1.27 (2014-05-21)

Support for the [Initial View](http://academy.appgyver.com/guides/107/); iOS Simulator updated to use v3.1.6-p3 native runtime (with bugfixes); new projects install Steroids.js via Bower.

Features:
  - Support for `steroids.config.initialView` in `config/application.coffee`to set an initial view that will be shown before the rest of the app is loaded.
  - `generator-steroids` dependency updated to v0.3.3.

Changes:
  - `steroids create` tries to be more informative after npm install
  - `ios-sim` is now included as its own npm package instead of being included with `steroids-simulators`

Bugfixes:
  - `ios-sim` has been updated to fix simulator starting with black screen https://github.com/phonegap/ios-sim/issues/86
  - iOS Simulator updated to use native runtime v3.1.6-p3

## 3.1.26 (2014-05-14)

Support for new `config/application.coffee` features introduced with iOS v3.1.5 runtime.

Features:
  - `generator-steroids` dependency updated to v0.3.2.
  - iOS Simulator updated to [v3.1.5-p3](https://github.com/AppGyver/scanner/blob/master/changelog-ios-patch-edge.md#315-p3-2014-05-13).
  - `config/application.coffee` supports `steroids.config.navigationBar.borderSize` and `steroids.navigationBar.borderColor` properties for setting a border on the bottom of the navigation bar (iOS only).
  - `config/application.coffee` supports `steroids.config.preloads`, an array of WebViews to preload before the application starts in the format `{ id: "myId", location: "myLocation.html" }`.
  - `config/application.coffee` supports `sterods.config.drawers` for setting up drawers before the application starts.
  - New projects' `config/application.coffee` includes example usage for all new config properties.

Changes:
  - `dist/__appgyver_settings.json` (used by CLI to read new configs) now includes only preferences actually used.

Secret features:
  - `--noSettingsJson` flag for `steroids make` (and thus `steroids) to not create the `dist/__appgyver_settings.json` file.

## 3.1.25 (2014-05-06)

Fixed crashing bug caused by an error with how `steroids.navigationBar.borderSize` and `steroids.navigationBar.borderColor` were handled.

## 3.1.24 (2014-05-06)

New projects now include Steroids.js v3.1.9 by default. Simulator app updated to v3.1.5 runtime.

Changes:
  - `generator-steroids` updated to [v0.3.1]
  - Simulator app updated to v3.1.5.

Secret features:
  - `config/application.coffee` supports `steroids.config.navigationBar.borderSize` and `steroids.navigationBar.borderColor` properties for setting a border on the bottom of the navigation bar (iOS only).
  - `config/application.coffee` supports `steroids.config.preloads`, an array of WebViews to preload before the app starts in the format `{ id: "myId", location: "myLocation.html" }`

## 3.1.23 (2014-04-25)

`generator-steroids` updated to [v0.3.0](https://github.com/AppGyver/generator-steroids/blob/master/CHANGELOG.md#030-2014-04-25), changes listed below:

Changes:
  - New projects include the Ionic CSS framework instead of Topcoat.
  - `ng-resource` generator updated to use the Ionic CSS framework and the latest version of AngularJS.
  - `tutorial` generators updated to use the Ionic CSS framework.
  - `example` generators updated to use the Ionic CSS framework, several example generators deprecated.
  - `bb-scaffold`, `ng-scaffold`, `ng-sql-scaffold` and `ng-touchdb-resource` generators deprecated.

## 3.1.22 (2014-04-03)

Update `generator-steroids` dependency to [v0.2.20](https://github.com/AppGyver/scanner/blob/master/changelog-ios.md#314-2014-04-03). Updated iOS Simulator binary to [v3.1.4](https://github.com/AppGyver/scanner/blob/master/changelog-ios.md#314-2014-04-03).

## 3.1.21 (2014-03-12)

Fixes XCode 5.1 issue with iOS Simulator.

Bugfixes:
  - iOS Simulator could not start with XCode 5.1.

## 3.1.20 (2014-03-05)

Karma test runner improvement. Support for `steroids.logger`

Features:
  - Karma runner cleans up `test/karmaSingle.lastrun.coffee` after done

Secret features:
  - Initial support for `steroids.logger.log()`

Chores:
  - Initial tests for Karma

## 3.1.19 (2014-02-27)

Updated iOS Simulator's Scanner binary to v3.1.3. Updated `grunt-steroids` dependency to v0.2.18.

## 3.1.18 (2014-02-26)

Fixes Karma testing.

Bugfixes:
  - Fixed tests (`npm test`) to work again.
  - Fixes missing `karma-jasmine` dependency for `steroids test karma`.

## 3.1.17 (2014-02-11)

Fixed bug with project zipping on Windows, Ripple re-enabled, Karma test runner updated with support for running only one spec.

Bugfixes:
  - Fixed bug where the `steroids_project.zip` file would not be generated on Windows.

Features:
  - Ripple re-enabled and updated to latest version (N.B. the official 3.x Ripple version is missing a lot of features/APIs that were present in 2.x Ripple).
  - Karma test runner updated to 0.11.14.
  - Karma test runner can now run only one spec as a faster alternative to running the whole suite.

## 3.1.16 (2014-02-10)

Support for Scanner v3.1.2 features in new project's `config.xml` files, updated iOS Simulator to v3.1.2, bugfixes.

Features:
  - [`generator-steroids`](http://www.appgyver.com/steroids/) dependency updated to v0.2.15 to support deafult projects' new `config.xml` options for Scanner v3.1.2 features.
  - iOS Simulator updated to Scanner v3.1.2.

Bugfixes:
  - Fixed a bug where a `dist/` folder with too many files could cause a `stdout maxBuffer exceeded` error. Thanks to [@drewrothstein](https://github.com/drewrothstein) for the pull request!
  - Steroids karma test runner did not give any debug output

## 3.1.15 (2014-01-24)

Steroids Safari debug command improved (run with `$ steroids safari`, or `debug` in `$ steroids connect` console). Thanks to [@mklement0](https://github.com/mklement0) for the pull request!

Bugfixes:
 - Safari debug now also works if the iPad is being simulated (not just iPhone).
 - Safari debug should now also work when Safari runs in localized mode (in a different UI language).

Features:
 - Proper error handling and reporting for Safari debug.
 - When running Safari debug from the `$ steroids connect` console, the command prompt doesn't redisplay until after the spawned tasks exit.
 - Safari debug now tries to turn on Access for Assistive Devices (required by the AppleScript commands).
 - Safari debug now times out with a helpful message if the relevant menu items in Safari cannot be found.
 - Safari debug now only activate (as opposed to launch in the background) Safari when it's truly necessary.

## 3.1.14 (2014-01-22)

Fixes an issue with 3.5" iOS Simulator

Bugfixes:
  - iOS Simulator for 3.5" device fixed by updating `ios-sim` of `steroids-simulators` package (https://github.com/AppGyver/steroids/issues/56)

## 3.1.13 (2014-01-14)

Fixed an issue with the `ng-sql-scaffold` generator.

Bugfixes:
  - The `ng-sql-scaffold` generator no longer includes the plugin JavaScript file (it is instead included automatically by Cordova).

## 3.1.12 (2013-12-27)

`$ steroids generate` generators that install Bower dependencies no longer fail on Linux and Windows.

Bugfixes:
  - Generators that install Bower dependencies no longer fail on Linux and Windows (fixed by updating `generator-steroids` Node module to 0.2.12).

## 3.1.11 (2013-12-23)

Ensures that all Bower components have been installed.

Features:
  - Ensures that all Bower components are installed when running `$ steroids make`.

## 3.1.10 (2013-12-19)

AppGyver Forums in connect page.

Changes:
  - QR Code page cleanup + AppGyver forums embedded

## 3.1.9 (2013-12-19)

Added migration script to circumvent a rare npm dependency issue.

Changes:
  - Installation now prints an annoying message.

Bugfixes:
  - Added migration script to fix an issue issue where migrating an old project to 3.1.4, deleting the `node_modules` folder and running `npm install` caused an error.

## 3.1.8 (2013-12-19)

Includes 3.1.1 simulator for iOS.

Changes:
  - Updated simulator to 3.1.1

## 3.1.7 (2013-12-16)

Fixes Linux compatibility for `steroids generate tutorial`.

Bugfixes:
  - Tutorial generator had an incorrectly capitalized folder name, leading to errors on Linux/Windows.

## 3.1.6 (2013-12-14)

Fixes Linux compatibility.

Bugfixes:
  - "q" package was required as "Q"

## 3.1.5 (2013-12-13)

Check for existence of `node_modules` in project root before trying to run Grunt tasks.

Features:
  - `steroids make` now checks for existence of `node_modules` directory in project root before trying to run Grunt tasks.

## 3.1.4 (2013-12-12)

Steroids [Grunt.js](http://gruntjs.com) tasks are now defined in the [`grunt-steroids`](https://github.com/appgyver/grunt-steroids) Grunt plugin and configured via a `Gruntfile.js` in project root. See the [Gruntfile guide](http://guides.appgyver.com/steroids/guides/project_configuration/gruntfile) for more information about the new Grunt setup. Running `$ steroids make` takes you through the necessary migration steps.

`$ steroids generate` and `$ steroids create` now use a [Yeoman](http://yeoman.io) Generator internally. You can find the [generator-steroids repo on GitHub](https://github.com/appgyver/generator-steroids).

Features:
  - Grunt update:
    - `steroids make` (run internally as part of `steroids connect`) now uses `Gruntfile.js` from project root to run make tasks.
    - Default Steroids Grunt tasks (`steroids-make` and `steroids-compile-sass`) are now defined in the `grunt-steroids` Grunt plugin.
    - The `grunt-steroids` npm package is included as a dependency for new projects.
    - `$ steroids update` ensures that existing projects have proper `Gruntfile.js` and `package.json`
  - Yeoman update:
    - `steroids generate` and `steroids create` use the [generator-steroids](https://github.com/appgyver/generator-steroids) Yeoman generator

Changes:
  - Creating a new project also installs npm dependencies from the default project template.
  - `$ steroids update` installs both Bower and npm dependencies.
  - `steroids make` fails without a `Gruntfile.js` in project root.
  - `--no-sass` argument for `steroids connect` removed. Instead, you can now remove the `steroids-compile-sass` task from the default Grunt task setup in `Gruntfile.js`.
  - `steroids generate resource` deprecated.

## 3.1.3 (2013-12-11)

Default license for new projects is now "none" instead of "MIT".

## 3.1.2 (2013-12-09)

Dummy update so that 3.1.x is latest in npm.

## 3.1.1 (2013-12-04)

Clarified validation instructions for `config.android.xml`.

## 3.1.0 (2013-12-04)

Features:
  - New projects have a `package.json` file (currently, only the `engines.steroids` field is used by Steroids CLI).
  - `steroids make` checks for `engines.steroids` version in `package.json` and runs a migration script if the version doesn't match the current one.
  - `steroids make` checks for `config.ios.xml` and `config.android.xml` validity.
  - iOS Simulator updated to v3.1.0.
  - Steroids.js updated to v3.1.0.

Changes:
  - **BREAKING:** `cordova.js` must now be loaded from localhost root, e.g. `http://localhost/cordova.js`.
  - **BREAKING:** Default `config.ios.xml` and `config.android.xml` updated to be Cordova 3.1.0 compatible.
  - Default project now loads `index.html` from localhost.
  - All generator examples and resources refactored to work with Cordova 3.1.0.
  - Ripple emulator disabled due to issues with Cordova 3.1.0, will be re-enabled in an upcoming release.

Bugfixes:
  - `onerror.js` removed from examples not on localhost to prevent Android issues.

## 2.7.39  (2013-12-03)

Bugfixes:
  - New projects' default CSS now sets `-webkit-user-select` correctly for elements with the `contenteditable` attribute
  - Fixed config.tizen.xml template which had screen resolution which was not accepted by Tizen Application Store.

Changes:
  - If `config/cloud.json` is present (application has been deployed), then application uses the id of deployment in local development mode. If application hasn't been deployed, id is "1" as previously.

## 2.7.38 (2013-11-15)

New steroids.js, Barcode Scanner plugin inclusion fixed.

Changes:
  - Default project's `steroids.js` file updated to v2.7.11

Bugfixes:
  - Fixed default plugin tag for Barcode Scanner in new projects' `www/config.ios.xml`.
  - Usage texts for Steroids commands improved.

## 2.7.37 (2013-10-25)

SASS compile can be disabled, Chrome opened in Windows when Ripple is started.

Changes:
  - `steroids connect --no-sass` and `steroids make --no-sass` implemented.

Bugfix:
  - windows: `steroids connect --serve --ripple` opens chrome correctly

## 2.7.36 (2013-10-25)

Fatal typo in preinstall script fixed, installation works again in Mac OS X Mountain Lion.

Bugfix:
  - Typo in preinstall script fixed.

## 2.7.35 (2013-10-25)

Hotfix preinstall script to allow bypass.

Bugfix:
  - Allows bypass of preinstall script.

## 2.7.34 (2013-10-25)

Hotfix for Steroids CLI preinstall script for OSX Mavericks

Bugfixes:
  - Detection of XCode CLI tools failed in Mavericks, thanks @jakecraige!

## 2.7.33 (2013-10-25)

Steroids npm preinstall script improved, Karma tests can be run in the iOS Simulator without the QR code page opening.

Changes:
  - `$ steroids test karma` does not open a QR code web page if the `--simulator` flag is enabled.
  - Changed default `config/application.coffee` `steroids.config.navigationBar.buttonTintColor` to white for a more unified color scheme on iOS 7.

Bugfixes:
  - Installing Steroids via npm properly checks for presence of XCode and XCode Command Line Tools on OS X.
  – Default `www/stylesheets/application.css` no longer makes `textarea` unselectable

## 2.7.32 (2013-10-22)

Karma integration for running unit tests on your device, usability improvements to `$ steroids update` and `$ steroids deploy`

Features:
  - Implemented `$ steroids test karma` for running unit tests on your device with the Karma test runner.

Changes:
  - `$ steroids update` prompts user to remove `myProject` from `www/components` if one has been generated.
  - `$ steroids deploy` prints `share.appgyver.com` URL without `--debug`.

## 2.7.31 (2013-10-21)

Fixed `$ steroids update` to use `bower.json` from project root.

Changes:
  - Default `bower.json` in a new project moved to project root instead of `www/` folder.
  - `$ steroids update` prompts user to move `bower.json` from previous default location

## 2.7.30 (2013-10-17)

Tab bar and navigation bar background images, iOS Simulator binary updated, default `steroids.js` version updated, Tizen bugfixes.

Features:
  - `config/application.coffee` now has support for tab bar and navigation bar background images.
  - Default project's `steroids.js` file updated to v2.7.10
  - iOS Simulator updated to v2.7.9

Changes:
  - Removed PushPlugin tag from default `www/config.ios.xml` (integrated PushPlugin was removed from Scanner).
  - Default app icon included in `www/icons/steroids.png`.

Bugfixes:
  - `steroids connect --serve` now correctly serves `cordova.tizen.js` from a local file.
  - `www/config.tizen.xml` default values fixed to prevent errors in Build Service.

## 2.7.29 (2013-10-16)

Fixed Linux-only crashing bug with `$ steroids connect`.

## 2.7.28 (2013-10-15)

Updated default projects' Steroids.js version to 2.7.9.

## 2.7.27 (2013-10-15)

Added Tizen support. Steroids Web Serve now supports Ripple.

Changes:
  - Removed deprecated hostfaking settings from `config/application.coffee`.
  - Added support for Ripple: `steroids connect --serve --ripple`.
  - Added Tizen Web Simulator, see `steroids usage`.
  - Default projects' `www/index.html` now includes a meta viewport tag.
  - Default projects have a `www/config.tizen.xml` file for configuring a Tizen Web App.

## 2.7.26 (2013-10-04)

New projects have initial compatibility with [Cordova CLI](https://github.com/apache/cordova-cli), cleaned up `config/application.coffee`.

Changes:
  - New Steroids projects have initial compatibilty with [Cordova CLI](https://github.com/apache/cordova-cli).
  - Removed text shadow color settings from project template's `config/application.coffee` (deprecated by iOS7).
  - Removed up comments and instructions from project template's `config/application.coffee`.
  - Removed obsolete Scanner client version check.

## 2.7.25 (2013-09-27)

Updated SQlite plugin JavaScript file in `ng-sql-scaffold` generator.

Bugfixes:
  - Updated SQlite plugin JavaScript file in `ng-sql-scaffold` generator to match the SQlite plugin version in iOS Scanner v2.7.8.

## 2.7.24 (2013-09-27)

Default project template updated to use Steroids.js v2.7.8, improved test running, optional QR code display in console.

Changes:
  - Optional QR code display in the console with `--terminal-qrcode`
  - Test running is now improved: `./bin/test fast` and `./bin/test spec/Version.spec.coffee` in addition to full suite (`npm test`)
  - Project templates updated to use Steroids.js v2.7.8

Bugfixes:
  - Removed `www/components/myProject/` Bower component folder from project template and added it to `.gitignore`.

## 2.7.23 (2013-09-20)

Updated Steroids Simulator app to support iOS7 UI (users also need to update Xcode and install the actual iOS7 Simulator).

## 2.7.22 (2013-09-16)

Polished generator templates and added error handling to deploy.

Bugfixes:
  - Removed line trying to load `controllers/application.js` from generator templates where the file wasn't used.
  - Display error message if deploy fails because access is denied.

## 2.7.21 (2013-09-09)

Fixed issue where certain Android devices couldn't open projects when using the Steroids npm on Windows, support for symbolic links in project, minor debug fixes.

Bugfixes:
  - In `$ steroids package` on Windows, use 7zip command-line executable instead of node-archiver to create the project zip. This fixes an issue where certain Android devices couldn't open the created project archive.
  - `$ steroids deploy --debug` outputs the share.appgyver.com URL to Terminal before trying to open it in the browser.
  - `$ steroids make` now copies symbolic links to `dist/`.

## 2.7.20 (2013-09-06)

Clarified instructions on updating the Steroids npm to work on a newer Node.js version.

Bugfixes:
  - Preinstall and preupdate Node.js version check now has a note about having to use `$ npm install steroids -g` instead of `$ npm update steroids -g`, if previous install was on Node 0.8.x.

## 2.7.19 (2013-09-06)

WINDOWS SUPPORT ADDED!

Also: Node.js version requirement is now v0.10.x (with v0.11.x supported), minor fixes based on forum feedback.

Breaking:
  - Doesn't work any more with Node v0.8.x.

Changes:
  - Updated Steroids npm to use Node.js version 0.10.x (with v0.11.x also supported).
  - Windows support added.

Bugfixes:
  - When the local QR code is shown, the web page URL is shown in the `--debug` output (i.e. `$ steroids connect --debug`).

Known Issues:
  - The `e`/`edit` shortcut for opening a text editor from the Steroids console crashes if the editor command is not found.
  - The `e`/`edit` shortcut in Steroids console is not available on Windows.

## 2.7.18 (2013-09-03)

Fixes issues reported in the forums, <3 [forums.appgyver.com](http://forums.appgyver.com).

Bugfixes:
  - Login callback, local QR code and Weinre web pages and `$ steroids connect --serve` now open using `127.0.0.1` instead of `localhost` to fix issues with non-standard hosts files.
  - New project plugins folder README file includes link to https://github.com/AppGyver/steroids-plugins.
  - `http://localhost/` URLs no longer get the `:13101` port appended to them automatically.

## 2.7.17 (2013-08-21)

Changes:
  - Updated Steroids.js to version 2.7.7

## 2.7.16 (2013-08-20)

Support for merges dir.

Changes:
  - New projects have Cordova like `merges` and `plugins` directories.
  - Added `merges` directory support to steroids make process.
  - New projects have `.gitignore` for `.DS_Store` and `/dist`.

Bugfixes:
  - Fallback for login url open (print to console)

## 2.7.15 (2013-08-19)

Changes:
  - Updated Steroids.js to version 2.7.6

Bugfixes:
  - More informative QR code screen
  - `ng-sql-scaffold` now includes `sqliteplugin.android.js` for Android Cordova SQLite plugin compatibility

## 2.7.14 (2013-08-14)

Fixed a crashing error on Linux.

Bugfixes:
  - fixed a crashing error caused by a typo'd require statement having the wrong case for the filename (the bug only affected Linux users due to Linux observing a stricter case sensitivity for the file system compared to OS X)

## 2.7.13 (2013-08-09)

Unified steroids commands, nicer usages and other improvments.

Changes:
  - `steroids connect --watch --watchExclude` option added to exclude paths and files, see also application.coffee option for more permanent excludes
  - `steroids debug` renamed to `steroids weinre`
  - `steroids safaridebug` renamed to `steroids safari`
  - `steroids safari` now lists open WebViews
  - `steroids safari <path>` opens the target document directly in Safari Dev Tools, also accepts partial paths
  - `d` and `debug` commands in the `steroids connect` prompt work as a shortcut for `steroids safari`
  - `steroids serve` is deprecated, use `steroids connect --serve`
  - `steroids usage` is now colorized and has better wording
  - iOS simulator can't be stopped anymore (it will always stop before starting again, this fixes bugs with resolution changes)

## 2.7.12 (2013-08-08)

Bugfixes and experimental feature of reloading with steroids connect --serve

Changes:
  - `steroids connect --serve` now reloads documents when `steroids push` is made

Bugfixes:
  - `ng-touchdb-resource` did not match semantic version of steroids-js
  - `steroids serve` did not work without tabs

## 2.7.11 (2013-08-08)

Changes:
  - New generator: `steroids generate ng-sql-scaffold` for an AngularJS CRUD scaffold with Persistence.js and WebSQL/SQLite-plugin as a backend
  - `steroids connect --serve` also serves application for browser debuggin
  - preMake hook will end the process when error code is not 0
  - `steroids serve` opens URL configured in `steroids.config.location` or the first tab if tabs are enabled.
  - `ng-resource` generator refactored to use a single JSON file for local resource data
  - `steroids serve` rewrites apps with tabs to support debugging with browser (experimental)
  - default `www/config.platform.xml` exposes built-in plugins
  - steroids.js 2.7.4 is default for new apps.

## 2.7.10 (2013-08-02)

New generators, build hooks invoked on file system changes, command to open Safari Develop menu directly, steroids.js version updated.

Changes:
  - `steroids safaridebug` opens the Safari Develop menu using AppleScript, allowing for quick access to Safari Web Inspector
  - new generator: `steroids generate ng-touchdb-resource` for an Angular.js resource that syncs data in an external CouchDB database with a local TouchDB database.
  - new generator: `steroids generate bb-scaffold` for a CRUD scaffold using Backbone.js, includes example configuration for Stackmob (or any REST-API)
  - steroids.js 2.7.3 is default for new apps.

Bugfixes:
  - `steroids.config.hooks.preMake` and `postMake` are now invoked with `--watch` option

## 2.7.9 (2013-07-29)

Simulator supports different SDKs, bugfixes

Changes:
  - `steroids simulator --deviceType` supports SDK version setting, `--deviceType=iphone@5.1`
  - includes 2.7.6 version of the iOS Scanner Simulator

Bugfixes:
  - `steroids.config.hooks.preMake`  and `postMake` are actually executed when update is triggered from connect prompt
  - Fixed "Using native drawer shows black drawer" problem with newer Simulator (2.7.6)
  - `steroids generate ng-resource` doesn't generate order by code anymore

## 2.7.8 (2013-07-26)

Lovin' Angular.js! Proper "Multi-Page Application" generators: ng-resource and ng-scaffold!

Changes:
  - `steroids generate ng-scaffold todo` generates a CRUD scaffold, includes example configuration for Stackmob (or any REST-API)
  - `steroids generate ng-resource animal` generates a local resource with local data in `www/data`

## 2.7.7 (2013-07-25)

iOS simulator launching is improved, console.log override to work around Cordovas bug.

Changes:
  - Added support for default iOS simulator device type launching with `steroids connect --deviceType=<type>`
  - `www/javascripts/console.log.js` added to catch `console.log` messages before Cordova is ready.
  - removed `steroids chat` command, please visit our forums at http://forums.appgyver.com

Breaking changes:
  - `steroids simulator --type` is now longer supported, changed to `steroids simulator --deviceType=<type>`

## 2.7.6 (2013-07-16)

Fixes iOS simulator height.

Bugfixes:
  - iOS simulator now extends to full height when started with `--type=iphone_retina_4_inch`
  - calling steroids commands with `--debug` did not output anything

## 2.7.5 (2013-06-17)

Resources generated with `steroids generate` use Topcoat, fixes to generated examples, Ratchet CSS library removed

Changes:
  - Removed obsolete rename-config-xml grunt task
  - Generator `resource and `ng-resource` now use Topcoat
  - Removed Ratchet CSS library from default project

Bugfixes:
  - Fixed default project template loading screen spinner size
  - Generated camera example uses Topcoat loading spinner, rotates images correctly, iPad camera roll popover positioned correctly
  - Generated photo gallery example rotates images correctly
  - Minor fixes to other generated examples

## 2.7.4 (2013-06-14)

Android bugfixes, tutorials updated for better clarity, Topcoat CSS library used in default project, tutorials and examples

Bugfixes:
  - onerror.js.android changed to onerror.android.js in default project template
  - Several examples fixed for Android

Changes:
  - Default project, loading.html, all tutorials and all examples now use Topcoat for CSS styles
  - Updated all tutorials for better clarity

## 2.7.3 (2013-06-11)

New Cordova examples, Android loading screen, index.html info text clarified

Bugfixes:
  - Default `index.html` had wrong instructions about scanning another app or restarting the current one on Android

Changes:
  - Default `www/loading.png` file added to new project template, used by the Android loading screen. See the [loading.png guide](http://guides.appgyver.com/steroids/guides/android/loading-png/) for more information.
  - Cleaned up `www/config.android.xml` from unused elements. See the [Android config.xml guide](http://guides.appgyver.com/steroids/guides/project_configuration/config-xml-android/)) for more information.
  - New Cordova examples: `storage` and `notification`
  - Generators that added a jQuery dependency now use jQuery 2.0.x
  - Generators that added an Angular.js dependency now use Angular.js 1.0.7
  - Friendlier error message for 'steroids' tutorial config/application.coffee overwrite
  - Cleaned up `config/application.coffee`

## 2.7.2 (2013-06-10)

Installation and tutorial improvements

Bugfixes:
  - `controllers` tutorial gives a proper error if the user tries to generate it before generating the `steroids` tutorial
  - Check for correct node version before installing to avoid issues

## 2.7.1 (2013-06-04)

Updated iOS Simulator and Steroids.js with support for new API's

Changes:
  - Application skeletons are generated with steroids-js 2.7.1
  - iOS Simulator updated to 2.7.1
  - `steroids chat` opens support chat
  - New tutorial `steroids`
  - `controllers` tutorial updated to reflect changes to other tutorials

Bugfixes:
  - Checks new versions using semantic versioning

## 2.7.0 (2013-06-03)

Public beta release

Changes:
  - default project now includes instructions on how to access AppGyver Scanner context menu
  - 'begin' tutorial remade

## 0.10.17 (2013-06-03)

Improved simulator

Changes:
  - `steroids simulator` now accepts --type to specify the device's type.

Bugfixes:
  - Simulator launch failure detection improved

## 0.10.16 (2013-05-31)

Update checking improved

Changes:
  - `steroids update` also checks for updates

Bugfixes:
  - Wrong message was displayed when new NPM was available

## 0.10.15 (2013-05-31)

config.ios.xml and config.android.xml

Changes:
  - Require login for local development due update checking for different user groups
  - Cordova.plist deprecated and replaced with config.ios.xml (Android config.xml support is upcoming)
  - added loading screen tint color to config/application.coffee

## 0.10.14 (2013-05-30)

Client update checking, Linux compatibility

Changes:
  - Automatically checks for new versions of AppGyver Scanner

Bugfixes:
  - Compatibility with sh shell in preinstall script
  - Prevent simulator launching in other OS than Mac OS X

## 0.10.13 (2013-05-29)

Custom editor, hooks and more consistency with Cordova

Changes:
  - a new app is served via the File protocol by default (instead of localhost)
  - editor launching is defined in `application.coffee`
  - steroids.config.hooks.preMake and steroids.config.hooks.postMake for running own scripts
  - steroids update checking passes the action performed
  - steroids update checking passes the user_id of currently logged in user

## 0.10.12 (2013-05-24)

Weinre updated, bugfixes

Changes:
  - `steroids update` informs if Steroids NPM is in the latest version
  - login and logout give nicer output
  - updated weinre (more supported browsers)
  - disabled unicode pill in prompt :(

Bugfixes:
  - enabling, disabling and enabling tabs again fixed
  - application.coffee is now properly reloaded on every client refresh
  - `steroids debug` works correctly with custom ports
  - Cordova camera example now shows a loading spinner while the captured photo is loading
  - better error handling in Cordova compass example
  - if project directory contains word "app" its not replaced as "dist"

## 0.10.11 (2013-05-23)

Custom port caused problems when not used (defaults did not work), fixed ng-resource

Bugfixes:
  - Custom --port settings bettered, ports back to defaults
  - angular type checking was not included in the last bug fix

## 0.10.10 (2013-05-22)

Bug fixes, better notifications

Changes:
  - Also running update, login and deploy check for new version

Bugfixes:
  - Fixed EventEmitter memory leaking
  - example generator output gave an incorrect location for the created layout file.

## 0.10.9 (2013-05-21)

Fixed resource generation

Changes:
  - Steroids update checking no longer hammers npm repository

Bugfixes:
  - resource and ng-resource generators did not tell the location of index view.
  - ng-resource angular defined checking was not done correctly

## 0.10.8 (2013-05-20)

New examples

Changes:
  - `steroids connect --port 1234` is supported, requires iOS client 2.7.0 to work.
  - Allow `steroids generate` to be run without being in a Steroids project folder (displays usage)
  - New examples added (accessible via `steroids generate example exampleName`):
    - Cordova: accelerometer, audio, camera, compass, device, geolocation
    - Steroids: drumMachine, photoGallery

Bugfixes:
  - `steroids connect` checks if port is taken.
  - `steroids deploy` gives more help and explains how deploy works when deployed.

## 0.10.7 (2013-05-16)

Tutorial flow fixed, updated generators

Changes:
  - Default generators no longer generate application.html or application.js files

Bugfixes:
  - Tutorial had typos and flow was broken.
  - Controllers tutorial did not check for file overwrites

## 0.10.6 (2013-05-16)

Friendlier error messages, error handling and bugfixes

Changes:
  - All steroids http callbacks are now prefixed with `/__appgyver`
  - `steroids connect` screen now links to AppGyver Scanner for Android also.
  - More verbose output on CoffeeScript and Sass compiliation (to see error messages in context)
  - Shows logo in `steroids create newProject`

Bugfixes:
  - When using `steroids serve` it no longer serves usage document for `/index.html`
  - Friendlier error messages for `steroids create` and `steroids generate`
  - Friendlier error messages for `steroids generate tutorial` and `steroids generate example`
  - Checks if `steroids <cmd>` needs to be run in steroids project directory
  - Any IP address that is not for localhost is okay
  - `steroids create projectName` refuses to overwrite existing folder
  - Default index.html had old tutorial generator command

## 0.10.5 (2013-05-14)

Bigger QR code for improved scanning.

Changes:
  - QR Code in `steroids connect` is bigger by default (improves scanning with iOS)

Bugfixes:
  - Steroids no longer assumes that command is always named `steroids`
  - Built-in grunt always used globally installed steroids

Experimental:
  - `steroids chat <nickName>` opens a support chat session

## 0.10.4 (2013-05-08)

New example generation syntax, new examples

Changes:
  - Example generator now uses following syntax:
    `steroids generate example modal`
  - New examples: layerStack, navigationBar

Bugfixes:
  - modal generator had some copy-pasta, fixed.

## 0.10.3 (2013-05-07)

Modal and animation example generators

Changes:
  - `steroids generate modal modalExample` creates an example of using modal windows.
  - `steroids generate animation animationExample` creates an example of using animations.

## 0.10.2 (2013-05-07)

Preload example generator

Changes:
  - `steroids generate preload preloadExample` creates an example of preloading webviews.

Bugfixes:
  - Default `application.css` fixed to work with input elements while disabling other callouts.


## 0.10.1 (2013-05-07)

Drawer example generator

Changes:
  - `steroids generate drawer drawerExample` creates an example of the new native Facebook-like drawer.
  - Default `application.css` disables WebKit callouts on long press in new projects.
  - `steroids make` no longer complains about controllers named `xxxController`


## 0.10.0 (2013-05-06)

Versioned to 0.10.0 with 0.7.0 Steroids.js because of Scanner dependency on iOS (2.3.5)

## 0.9.10 (2013-05-02)

Updated Steroids.js references to 0.6.2

## 0.9.9 (2013-04-26)

Android compatibility

Changes:
  - www/javascripts/onerror.js.android overrides default onerror.js to prevent errors before
    the Android runtime doesn't throw an error on non-existing JavaScript files

## 0.9.8 (2013-04-25)

Default project structure is improved.

Changes:
  - Improved Angular.js generator (ng-resource)
  - loading.html looks better
  - Tutorial project is more informative: $ steroids generate tutorial begin
  - Everything works also with Android
  - Matches latest steroids.js conventions

## 0.9.7 (2013-04-15)

Linux compatibility.

Bugfixes:
  - Fixes `error: Error: Cannot find module './steroids/deploy'` on Linux, we used case insensitive filesystems.

## 0.9.6 (2013-04-12)

Notifies on updates.

Changes:
  - When running `steroids connect`, steroids will connect to npm repository to check for a newer version.
    If a newer version is found, a banner is printed with upgrade notice.

## 0.9.5 (2013-04-11)

Usability improvments.

Changes:
  - Opening http://youripaddress:4567 gives more friendlier page.
  - Simulator detects if it failed to launch and instructs on how to reset it.

## 0.9.4 (2013-04-10)

Start recommending NVM, the Node Version Manager

Changes:
  - Installation does not force user to chown `/usr/local`, readme recommends to use NVM.

## 0.9.3 (2013-04-09)

Deploy did not make a new deployment package.

Bugfixes:
  - `steroids deploy` did not make a new package in `/tmp/steroids_project.zip` that resulted in
    failure if no previous package was found or deploy was done with an older build.

## 0.9.2 (2013-04-09)

Linux compatibility

Bugfixes:
  - Only interfaces starting with "en" were embedded in QR code. Now everything but localhost is added.

## 0.9.1 (2013-04-08)

0.9.0 contained 0.6.0 steroids-js that was immediately updated to 0.6.1.

Bugfixes:
  - Sample projects use 0.6.1 that works (0.6.0 was broken)

## 0.9.0 (2013-04-08)

Released iOS Scanner 2.3.4 to App Store, updated minor to reflect that.

## 0.8.2 (2013-04-05)

Support for iOS Scanner 2.3.4

Changes:
  - new projects have a bower dependency to steroids-js package, instead of a github url
  - new projects are created with steroids-js 0.6.x dependencies

## 0.8.1 (2013-03-25)

Linux compatibility fix

Bugfixes:
  - Fixes `error: Error: Cannot find module './config'` on Linux, we used case insensitive filesystems.
    Thanks to Itzcoatl Calva.

## 0.8.0 (2013-03-22)

Support for iOS Scanner 2.3.3

Features
  - Support for iOS Scanner 2.3.3, refuses to work with 2.2.2 (steroids.js 0.5.0 requires 2.3.3)

## 0.7.2 (2013-03-20)

Changelog started (again)

Features:
  - QR code can be shown from connect prompt
  - Initial support for launching editors from connect prompt, currently hardcoded "mate"
  - p for push in connect prompt
