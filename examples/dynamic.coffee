ql = require 'odoql'
ql = ql
  .use 'store'

queries =
  query1: (ql [1, 2, 3, 4]
    .count()
    .query())
  query2: ql.store 'dataset'

console.log JSON.stringify queries, null, 2

dynamic = require 'odoql-exe/dynamic'
exe = require 'odoql-exe'
exe = exe()
  .use dynamic (keys, queries, cb) ->
    # send somewhere to query
    # e.g. in the browser do an ajax post to a dynamic query location
    # here we're actually returning the query as the query result
    cb null, queries

# odo-relay takes care of this sort of thing
cache = require 'odoql-exe/cache'
cache = cache exe
cache.on 'result', (result) ->
  console.log result
cache.run queries
