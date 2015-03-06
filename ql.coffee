extend = require 'extend'

module.exports =
  object: (query, params, graph) ->
    extend {}, graph,
      __odoql:
        query: query
        type: 'object'
        params: params
  array: (query, params, graph) ->
    extend {}, graph,
      __odoql:
        query: query
        type: 'array'
        params: params
  merge: (queries) ->
    # todo - merge queries properly
    result = {}
    for query in queries
      result = extend yes, result, query
  exec: (queries, stores) ->
    state = {}
    for key, graph of queries
      query = graph.__odoql
      store = stores[query.query]
      state[key] = store query, graph
    state