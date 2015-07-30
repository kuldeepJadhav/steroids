chalk = require 'chalk'

module.exports =
  ok: (messages...) ->
    console.log chalk.bold.green('>'), messages...
  error: (messages...) ->
    console.error chalk.bold.red("ERROR:"), messages...
  warning: (messages...) ->
    console.warn chalk.bold.yellow("WARNING:"), messages...

