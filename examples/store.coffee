ql = require 'odoql'
ql = ql
  .use 'store'

query = ql 'datasets'
  .store()
  .query()

console.log JSON.stringify query, null, 2

store = require 'odoql-store'
store = store()
  .use 'datasets', (params, cb) ->
    cb null, [
      { id: 1 }
      { id: 2 }
      { id: 3 }
      { id: 4 }
    ]

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-fs'
  .use require 'odoql-csv'
  .use require 'odoql-http'
  .use store

run = exe.build query
run (err, results) ->
  console.log results