AppGyver Steroids CLI [![NPM version](http://img.shields.io/npm/v/steroids.svg)](https://www.npmjs.org/package/steroids)
---------------------

AppGyver Steroids 2 is PhoneGap on Steroids, providing native UI elements, multiple WebViews and enhancements for better developer productivity.

## Build status


OS X / Linux: [![Build status in Travis CI](https://travis-ci.org/AppGyver/steroids.svg)](https://travis-ci.org/AppGyver/steroids)

Windows: [![Windows build status](https://ci.appveyor.com/api/projects/status/kbef0afl6cxu65qv?svg=true)](https://ci.appveyor.com/project/rdanderson/steroids)

## Requirements

* Node.js 0.10.x and NPM
* Git
* XCode and Command-line Tools (OS X only)

## Installing
**Please follow our [installation wizard](https://academy.appgyver.com/installwizard/) if you're new to the Node ecosystem and need help with the installation.**

Install Steroids globally with the `-g` flag:

    $ npm install steroids -g

Note that some third-party NPM packages might give warnings during the install project. These warnings shouldn't affect how the Steroids npm functions.

## Usage

    $ steroids create directory_name
    $ cd directory_name
    $ steroids connect

More usage information is available via

    $ steroids usage

## Development

After pulling from remote, to ensure all dependencies are updated properly:

    $ rm -rf node_modules

Install dependencies:

    $ npm install

Link your `steroids` folder into the global namespace:

    $ npm link

Run with `$ steroids` command.

## Documentation

* [AppGyver Docs](http://docs.appgyver.com)
* [Using Steroids CLI](http://docs.appgyver.com/steroids/cli/steroids-cli/local-development-flow/)
* [Get started with Supersonic](http://docs.appgyver.com/supersonic/tutorial/first-mile/#overview)

## Forums

[http://forums.appgyver.com](http://forums.appgyver.com)

## Bugs, feedback

Please report bugs into this repository's [issue tracker](https://github.com/AppGyver/steroids/issues/). Please include a repro and all information about the situation in which the bug appears, including OS, Steroids and Node version number, possible AppGyver Scanner versions etc.

We also want to get your feedback! Drop us a mail at contact@appgyver.com

## Testing npm

To run unit tests:

    $ ./bin/test release    # release testing, also creates required `__testApp`
    $ ./bin/test fast       # skip time consuming tests
    $ ./bin/test            # full test suite, skip setup (release)
    $ ./bin/test path/to/spec.coffee

## Contributing

We gladly accept pull requests! However, please include only one feature or fix per one pull request. It will be much easier to review and merge each contribution.

To develop Steroids-npm locally:

* Clone this repo and install its dependencies (`npm install`).
* Create a symlink from `/usr/local/bin/devroids` to your development Steroids executable.
* Use `devroids` as you would use `steroids`.

## Statistics

[![NPM](https://nodei.co/npm-dl/steroids.png?height=3)](https://nodei.co/npm/steroids/)
