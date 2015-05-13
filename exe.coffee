ops = require './ops'

isquery = require './isquery'

literal = (exe, value) -> (cb) -> cb null, value

module.exports =
  use: (def) ->
    providers = literal: literal
    res =
      providers: providers
      clear: ->
        providers = literal: literal
      use: (def) ->
        for _, optype of def
          for name, fn of optype
            providers[name] = fn
      build: (q) ->
        return res.providers.literal res, q unless isquery q
        if !res.providers[q.__q]?
          throw new Error "#{q.__q} not found"
        return res.providers[q.__q] res, q
    res.use def
    res.use def for def in ops
    res