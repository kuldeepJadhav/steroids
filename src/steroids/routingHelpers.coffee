module.exports =
  parseLocation: (location) ->
    parts = routePattern.exec location

    if parts?
      [whole, module, view, query] = parts
      path = "app/#{module}/#{view}.html#{query || ''}"
      "http://localhost/#{path}"
    else
      location

routePattern = /^([\w\-]+)#([\w\-\/]+)(\?.+)?$/
