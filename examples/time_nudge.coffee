console.log "OdoQL - #{new Date().toString()}"

ql = require 'odoql'
ql = ql
  .use 'time'

obs = [
  { time: '2014-12-31T17:00:00Z', value: 8 }
  { time: '2014-12-31T18:00:00Z', value: 8 }
  { time: '2014-12-31T19:00:00Z', value: 8 }
  { time: '2014-12-31T20:00:00Z', value: 8 }
  { time: '2014-12-31T21:00:00Z', value: 8 }
  { time: '2014-12-31T22:00:00Z', value: 8 }
]

fill = [
  { time: '2014-12-31T22:00:00Z', value: 9, prob: 5 }
  { time: '2014-12-31T23:00:00Z', value: 9, prob: 5 }
  { time: '2015-01-01T00:00:00Z', value: 9, prob: 5 }
  { time: '2015-01-01T01:00:00Z', value: 9, prob: 5 }
  { time: '2015-01-01T02:00:00Z', value: 9, prob: 5 }
  { time: '2015-01-01T03:00:00Z', value: 9, prob: 5 }
  { time: '2015-01-01T04:00:00Z', value: 9, prob: 5 }
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
  .time_nudge
    lookback: '-3h'
    range: '+5h'
    values: ['value']
    target: 'delta'
    key: 'value'
    data: (ql obs
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