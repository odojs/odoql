merge = require './merge'

module.exports = (args...) ->
  args.reduce (a, b) ->
    res = {}
    for key, query of a
      res[key] = query
    for key, query of b
      if res[key]?
        res[key] = merge res[key], query
      else
        res[key] = query
    res