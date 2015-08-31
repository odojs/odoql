console.log "OdoQL - #{new Date().toString()}"

curve = (x) ->
  return 2 * x * x if x < 0.5
  1 - 2 * (x - 1) * (x - 1)

console.log curve 0
console.log curve 0.25
console.log curve 0.5
console.log curve 0.75
console.log curve 1

## TODO
# join timeseries (two arrays with [time] field)
# obs nudge (two arrays with [time] fields - choose fields to nudge, choose nudge smoothing values)
# percentage delta (two arrays with [time] fields - choose fields to delta)
# timeseries max field
# timeseries min field

ql = require 'odoql'
ql = ql
  .use 'store'

report =
  queries:
    'Crux EC WRF': ql.store 'Crux EC WRF'
    'Crux EC ENS': ql.store 'Crux EC ENS'
    'Prelude EC WRF': ql.store 'Prelude EC WRF'
    'Prelude EC ENS': ql.store 'Prelude EC ENS'
    'Crux Waves': ql.store 'Crux Waves'
    'Browse Island Observations': ql.store 'Browse Island Observations'
  sources:
    'Crux EC WRF': ql.param 'Crux EC WRF'
    'Crux EC ENS': ql.param 'Crux EC ENS'
    'Prelude EC WRF': ql.param 'Prelude EC WRF'
    'Prelude EC ENS': ql.param 'Prelude EC ENS'
    'Crux Waves': ql.param 'Crux Waves'
    'Browse Island Observations': ql.param 'Browse Island Observations'
  data:
    author:
      name: 'Author'
      editor: 'author'
      source: 'Rob Davis'
    discussion:
      name: 'Discussion'
      editor: 'rich-text'
      source: 'Discussion goes here'
    meteo:
      name: 'Meteo'
      editor: 'meteo'
      source: ql.param 'Crux EC WRF'
      source2: ql.param 'Crux EC ENS'
      source3: ql.param 'Browse Island Observations'
    waves:
      name: 'Waves'
      editor: 'waves'
      source: ql.param 'Crux Waves'
    observations:
      name: 'Observations'
      editor: 'obs-feed-selector'
      source: ql.param 'Browse Island Observations'

store = require 'odoql-store'
store = store()
  .use 'Crux EC WRF', (params, cb) ->
    cb null, [1, 2, 3, 4]
  .use 'Crux EC ENS', (params, cb) ->
    cb null, [1, 2, 3, 4]
  .use 'Prelude EC WRF', (params, cb) ->
    cb null, [1, 2, 3, 4]
  .use 'Prelude EC ENS', (params, cb) ->
    cb null, [1, 2, 3, 4]
  .use 'Crux Waves', (params, cb) ->
    cb null, [1, 2, 3, 4]
  .use 'Browse Island Observations', (params, cb) ->
    cb null, [1, 2, 3, 4]

exe = require 'odoql-exe'
exe = exe()
  .use store

build = require 'odoql-exe/buildqueries'
build(exe, report.queries) (err, params) ->
  return cb err if err?
  sources = {}
  for key, source of report.sources
    sources[key] = ql.fill params, source
  build(exe, sources) (err, sources) ->
    for key, source of sources
      console.log "#{key}: #{JSON.stringify source}"
