ql = require 'odoql'
ql = ql()

data = [
  { name: 'one' }
  { name: 'two' }
  { name: 'three' }
  { name: 'four' }
]

query = ql 'test'
  .concat ql.param 'param1'
  .fill
    param1: 'name'
  .query()

console.log JSON.stringify query, null, 2

exe = require 'odoql-exe'
exe = exe()

exe.build(query) (err, results) ->
  console.log results