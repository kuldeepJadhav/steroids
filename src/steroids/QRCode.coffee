open = require "open"
qrcode = require "qrcode-terminal"

class QRCode
  constructor: (@options = {}) ->

  show: (options={})=>
    return if process.env.STEROIDS_TEST_RUN

    if steroidsCli.options.argv["terminal-qrcode"]
      qrcode.generate @options.data, (terminalQRCode) ->
        console.log terminalQRCode
    else
      steroidsCli.debug "QRCODE", "options data: #{@options.data}"
      urlToOpen = "http://localhost:#{@options.port}/__connect/connect.html?qrcode=#{encodeURIComponent(@options.data)}"

      steroidsCli.debug "Opening URL #{urlToOpen} in default web browser..."
      open urlToOpen

  @showLocal: (options={}) =>
    ips = steroidsCli.server.ipAddresses().slice(0, 3)
    steroidsCli.debug "QRCODE", "IPs: #{ips}"

    encodedJSONIPs = encodeURIComponent(JSON.stringify(ips))
    encodedPort = encodeURIComponent(options.port)

    qrCodeData = "appgyver://?ips=#{encodedJSONIPs}&port=#{encodedPort}"
    code = new QRCode
      data: qrCodeData
      port: options.port

    code.show(options)

module.exports = QRCode
