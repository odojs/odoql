ql = require 'odoql'
ql = ql
  .use 'csv'
  .use 'http'

query = ql 'http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv'
  .http()
  .csv
    header: yes
    skipEmptyLines: yes
  .count()
  .query()

console.log JSON.stringify query, null, 2

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-csv'
  .use require 'odoql-http'

run = exe.build query
run (err, results) ->
  console.log results