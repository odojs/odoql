jsonfilter = require './json-filter'
subqueries = {}

filltarget = (graph, item) ->
  return item if typeof graph isnt 'object'
  fillgraph graph, item

fillgraph = (graph, item) ->
  return null if !item? or item is null
  result = {}
  for key, shape of graph
    continue if !item[key]?
    target = item[key]
    if !shape.__odoql?
      result[key] = filltarget shape, target
      continue
    def = shape.__odoql
    if def.query?
      result[key] = subqueries[def.query.name] def, shape, target
      continue
    if def.type is 'array'
      result[key] = target.map (t) ->
        filltarget shape, t
      continue
  result

filterstore = (def, graph, data) ->
  results = jsonfilter data, def.query.filter
  results = results.map (result) ->
    fillgraph graph, result
  return results if def.type is 'array'
  return null if results.length is 0
  if results.length isnt 1
    throw new Error 'One needed, many found'
  return results[0]

subqueries['json-filter'] = filterstore

module.exports =
  subqueries: subqueries
  query: filterstore
  filter: jsonfilter