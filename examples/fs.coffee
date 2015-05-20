ql = require 'odoql'
ql = ql
  .use 'csv'
  .use 'fs'

query = ql './example.csv'
  .file()
  .csv
    header: yes
    skipEmptyLines: yes
  .assign
    wsp: ql.asFloat ql.ref 'wsp'
  .filter ql.gt(ql.ref('wsp'), 6)
  .shape
    wd: yes
  .query()

console.log JSON.stringify query, null, 2

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-csv'
  .use require 'odoql-fs'

run = exe.build query
run (err, results) ->
  console.log results