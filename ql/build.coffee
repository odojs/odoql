split = require './split'

module.exports = (query, stores) ->
  queries = {}
  query = split query, Object.keys stores
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