extend = require 'extend'
jsondiffpatch = require 'jsondiffpatch'
async = require 'odo-async'

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

diffisdelete = (diff) ->
  diff instanceof Array and diff.length is 3 and diff[1] is 0 and diff[2] is 0

ql =
  query: (name, params, shape) ->
    __query: name
    __params: params
    __shape: shape
  freshquery: (name, params, shape) ->
    __query: name
    __params: params
    __shape: shape
    __fresh: yes
  describe: (query) ->
    return '-- no query --' if Object.keys(query).length is 0
    'query\n' + Object.keys query
      .map (prop) ->
        "  #{prop} from #{query[prop].__query}"
      .join '\n'
  merge: (queries) ->
    return null if arguments.length is 0
    if arguments.length isnt 1
      queries = Array::slice.call arguments, 0
    return null if queries.length is 0
    result = {}
    merge result, extend {}, query for query in queries
    result
  # Return two queries, ones that match names and others that don't
  split: (query, names) ->
    known = {}
    unknown = {}
    for key, value of query
      if value.__query in names
        known[key] = value
      else
        unknown[key] = value
    known: known
    unknown: unknown
  diff: (prev, next) ->
    result = {}
    diff = jsondiffpatch.diff prev, next
    for key, value of diff
      continue if diffisdelete value
      # any changes require a re-query
      result[key] = next[key]
    for key, value of next
      if value?.__fresh?
        result[key] = value
    result
  build: (query, stores) ->
    queries = {}
    query = ql.split query, Object.keys stores
    for key, graph of query.known
      if !queries[graph.__query]?
        queries[graph.__query] =
          __query: graph.__query
          keys: []
          queries: {}
      queries[graph.__query].keys.push key
      queries[graph.__query].queries[key] = graph
    result = []
    for _, item of queries
      do (item) ->
        item.query = (cb) -> stores[item.__query] item.queries, cb
        result.push item
    if Object.keys(query.unknown).length is 0
      return result
    if !stores.__dynamic?
      return cb new Error 'Unknown queries'
    result.push
      __query: '__dynamic'
      keys: Object.keys query.unknown
      query: (cb) -> stores.__dynamic query.unknown, cb
      queries: query.unknown
    result
  exec: (query, stores, callback) ->
    query = ql.build query, stores
    console.log query
    errors = []
    tasks = []
    state = {}
    for q in query
      do (q) ->
        tasks.push (cb) -> q.query (err, results) ->
          if err?
            errors.push err
          else
            extend state, results
          cb()
    async.parallel tasks, ->
      if errors.length isnt 0
        return callback errors, state
      return callback null, state

module.exports = ql