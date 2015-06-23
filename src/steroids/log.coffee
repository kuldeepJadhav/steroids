chalk = require 'chalk'

module.exports =
  ok: (messages...) ->
    console.log chalk.bold.green('>'), messages...
  error: (messages...) ->
    console.log chalk.bold.red("ERROR:"), messages...
  warning: (messages...) ->
    console.log chalk.bold.yellow("WARNING:"), messages...

