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
  aarray = base instanceof Array
  barray = extra instanceof Array
  if aarray
    if !barray
      console.log 'Not an array, ignoring'
      console.log extra
      return base
    if base.length isnt 1 or extra.length isnt 1
      console.log 'Expecting length 1 arrays'
      console.log extra
      return base
    return [merge base[0], extra[0]]
  if base.__query?
    if !extra.__query?
      console.log 'Non query, ignoring'
      console.log extra
      return base
    unless eq base.__params, extra.__params
      console.log 'Query does not match, ignoring'
      console.log extra
      return base
    if !base.__shape? or !extra.__shape?
      return base
    merge base.__shape, extra.__shape
    return
  else if extra.__query?
    console.log 'Query, ignoring'
    console.log extra
    return base
  for key, value of extra
    if base[key]? and typeof value is 'object'
      merge base[key], value
      continue
    base[key] = value

module.exports =
  query: (name, query, shape) ->
    __query: name
    __params: query
    __shape: shape
  merge: (queries) ->
    return null if arguments.length is 0
    if arguments.length isnt 1
      queries = Array::slice.call arguments, 0
    return null if queries.length is 0
    result = {}
    merge result, extend {}, query for query in queries
    result
  exec: (queries, stores) ->
    state = {}
    for key, graph of queries
      store = stores[graph.__query]
      state[key] = store.query graph, store.subqueries
    state