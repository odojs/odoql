ql = require 'odoql'
ql = ql
  .use 'csv'
  .use 'time'
  .use 'fs'

query = ql './example2.csv'
  .file()
  .csv
    header: yes
    skipEmptyLines: yes
  .remove __parsed_extra: yes
  .rename
    time: 'DateTime'
    location: 'Location'
    wd: 'WindDir'
    wsp: 'WSpd10m'
    gst: 'Gust10m'
  .filter ql.eq 'Location 1', ql.ref 'location'
  .query()

console.log JSON.stringify query, null, 2

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-csv'
  .use require 'odoql-fs'
  .use require 'odoql-time'

exe.build(query) (err, results) ->
  console.log results