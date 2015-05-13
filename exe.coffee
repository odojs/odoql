builtin = [
  require './ops/boolean'
  require './ops/conditional'
  require './ops/maths'
  require './ops/transform'
]

isquery = require './isquery'

module.exports =
  use: (def) ->
    providers = literal: (exe, value) -> (cb) -> cb null, value
    res =
      providers: providers
      clear: ->
        providers = literal: (exe, value) -> (cb) -> cb null, value
      use: (def) ->
        for _, optype of def
          for name, fn of optype
            providers[name] = fn
      build: (q) ->
        return res.providers.literal res, q unless isquery q
        if !res.providers[q.__query]?
          throw new Error "#{q.__query} not found"
        return res.providers[q.__query] res, q
    res.use def
    res.use def for def in builtin
    res