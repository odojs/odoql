console.log "OdoQL - #{new Date().toString()}"

ql = require 'odoql'
ql = ql
  .use 'time'

data = [
  { '0.05': 10, '0.5': 20, '0.95': 30 }
  { '0.05': 15, '0.5': 25, '0.95': 35 }
  { '0.05': 20, '0.5': 30, '0.95': 40 }
  { '0.05': 25, '0.5': 35, '0.95': 45 }
]

query = ql data
  .assign
    value: (ql 0.45
      .interpolate_linear
        '0.05': ql.ref '0.05'
        '0.5': ql.ref '0.5'
        '0.95': ql.ref '0.95'
      .query())
  .query()

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-time'

exe.build(query) (err, results) ->
  console.log results