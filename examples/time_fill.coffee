console.log "OdoQL - #{new Date().toString()}"

ql = require 'odoql'
ql = ql
  .use 'time'

fill = [
  { time: '2014-12-31T23:00:00Z', value: 0, prob: 5 }
  { time: '2015-01-01T00:00:00Z', value: 1, prob: 5 }
  { time: '2015-01-01T01:00:00Z', value: 2, prob: 5 }
  { time: '2015-01-01T02:00:00Z', value: 3, prob: 5 }
  { time: '2015-01-01T03:00:00Z', value: 4, prob: 5 }
  { time: '2015-01-01T04:00:00Z', value: 5, prob: 5 }
]

query = ql [
    { time: '2015-01-01T00:00:00Z', value: 9 }
    { time: '2015-01-01T01:00:00Z', value: 9 }
    { time: '2015-01-01T02:00:00Z', value: 9 }
  ]
  .assign
    time: ql.time 'YYYY-MM-DD[T]HH:mm:ssZ', ql.ref 'time'
  .time_fill (ql fill
    .assign
      time: ql.time 'YYYY-MM-DD[T]HH:mm:ssZ', ql.ref 'time'
    .query())
  .assign
    time: (ql 'time'
      .ref()
      .time_delta '(UTC)'
      .time_format 'dddd, MMMM Do YYYY, h:mm:ss a'
      .query()
    )
  .query()

exe = require 'odoql-exe'
exe = exe()
  .use require 'odoql-time'

exe.build(query) (err, results) ->
  console.log results