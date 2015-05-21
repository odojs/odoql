library = require './library'

ql = (query, def) ->
  res =
    query: -> query
    clone: (deep) ->
      return ql query, def unless deep
      newquery = JSON.parse JSON.stringify query
      ql newquery, def
  for source in def
    for name, _ of source.params
      do (name) ->
        res[name] = (params) ->
          query = ql.params name, params, query
          res
    for name, _ of source.unary
      do (name) ->
        res[name] = ->
          query = ql.unary name, query
          res
    for name, _ of source.binary
      do (name) ->
        res[name] = (right) ->
          query = ql.binary name, query, right
          res
    for name, _ of source.trinary
      do (name) ->
        res[name] = (left, right) ->
          query = ql.trinary name, query, left, right
          res
  res

ql.params = (name, params, source) ->
  res =
    __q: name
    __p: params
    __s: source
  if !res.__p?
    delete res.__p
  res
ql.unary = (name, source) ->
  __q: name
  __s: source
ql.binary = (name, left, right) ->
  __q: name
  __l: left
  __r: right
ql.trinary = (name, params, left, right) ->
  __q: name
  __p: params
  __l: left
  __r: right

applyglobals = (res, def) ->
  for name, _ of def.params
    do (name) -> res[name] = (params, source) ->
      ql.params name, params, source
  for name, _ of def.unary
    do (name) -> res[name] = (source) ->
      ql.unary name, source
  for name, _ of def.binary
    do (name) -> res[name] = (left, right) ->
      ql.binary name, left, right
  for name, _ of def.trinary
    do (name) -> res[name] = (params, left, right) ->
      ql.trinary name, params, left, right

# attach methods against a query in progress
ql.use = (def) ->
  res = (query) ->
    ql query, res.providers
  for name, fn of ql
    res[name] = fn
  res.providers = []
  res.use = (def) ->
    if typeof(def) is 'string'
      if !library[def]?
        throw new Error "#{def} not found in library"
      def = library[def]
    if def instanceof Array
      res.use d for d in def
      return res
    applyglobals res, def
    res.providers.push def
    res
  res
  # attach methods against ql directly
  res.use library.builtin
  res.use def

applyglobals ql, library.builtin

module.exports = ql