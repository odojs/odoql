extend = require 'extend'

eq = (a, b) ->
  return yes if a is b
  return no if typeof a isnt 'object' or typeof b isnt 'object'
  return no if a is null or b is null
  aarray = a instanceof Array
  barray = b instanceof Array
  return no if aarray isnt barray
  if aarray
    return no if a.length isnt b.length
    for i in [0...a.length]
      return no unless eq a[i], b[i]
    return yes
  akeys = Object.keys a
  bkeys = Object.keys b
  return no if akeys.length isnt bkeys.length
  for key, value of a
    return no unless eq value, b[key]
  yes

merge = (base, extra) ->
  if base.__odoql?
    if !extra.__odoql?
      console.log 'Non query, ignoring'
      console.log extra
      return base
    unless eq base.__odoql, extra.__odoql
      console.log 'Query does not match, ignoring'
      console.log extra
      return base
  for key, value of extra
    continue if key is '__odoql'
    # todo: merge arrays
    if base[key]? and typeof value is 'object'
      merge base[key], value
      continue
    base[key] = value

module.exports =
  object: (graph, query) ->
    result = extend {}, graph,
      __odoql: type: 'object'
    return result if !query?
    result.__odoql.query = query
    result
  array: (graph, query, params) ->
    result = extend {}, graph,
      __odoql: type: 'array'
    return result if !query?
    result.__odoql.query = query
    result
  merge: (queries) ->
    # todo - merge queries properly
    result = {}
    merge result, extend {}, query for query in queries
    result
  exec: (queries, stores) ->
    state = {}
    for key, graph of queries
      def = graph.__odoql
      store = stores[def.query.name]
      state[key] = store def, graph
    state