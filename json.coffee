jsonfilter = require './json-filter'

fillproperty = (data, graph, subqueries) ->
  if graph.__odoql?
    subqueries[graph.__odoql.name] data, graph, subqueries
  else
    fillproperties data, graph, subqueries

fillproperties = (data, graph, subqueries) ->
  return null if !data? or data is null
  return data if typeof graph isnt 'object'
  result = {}
  for key, shape of graph
    continue if !data[key]?
    unless shape instanceof Array
      result[key] = fillproperty data[key], shape, subqueries
      continue
    unless data[key] instanceof Array
      throw Error 'Expecting array found ' + typeof data
    shape = shape[0]
    result[key] = data[key].map (d) -> fillproperty d, shape, subqueries
  result

executequery = (data, graph, subqueries) ->
  # if it's an array we return an array
  if graph.graph instanceof Array
    results = jsonfilter data, graph.__odoql.filter
    results = results.map (result) ->
      fillproperties result, graph.graph[0], subqueries
    return results
  # otherwise filter, fill and return one or none
  results = jsonfilter data, graph.__odoql.filter
  results = results.map (result) ->
    fillproperties result, graph.graph, subqueries
  return null if results.length is 0
  if results.length isnt 1
    throw new Error 'One needed, many found'
  return results[0]

module.exports = executequery