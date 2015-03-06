jsonfilter = require './json-filter'
subqueries = {}

fillprop = (data, graph) ->
  if graph instanceof Array
    unless data instanceof Array
      throw new Error 'Expecting array', data: data
    if graph[0].__odoql?
      def = graph[0].__odoql
      subqueries[def.name] data, graph
    else
      data.map (t) -> fillgraph t, graph[0]
  else if graph.__odoql?
    def = graph.__odoql
    subqueries[def.name] graph, data
  else
    fillgraph data, graph

fillgraph = (data, graph) ->
  return null if !data? or data is null
  return data if typeof graph isnt 'object'
  result = {}
  for key, shape of graph
    continue if !data[key]?
    result[key] = fillprop data[key], shape
  result

executequery = (data, graph) ->
  # if it's an array we return an array
  if graph instanceof Array
    graph = graph[0]
    results = jsonfilter data, graph.__odoql.filter
    results = results.map (result) ->
      fillgraph result, graph
    return results
  
  # otherwise filter, fill and return one or none
  results = jsonfilter data, graph.__odoql.filter
  results = results.map (result) ->
    fillgraph result, graph
  return null if results.length is 0
  if results.length isnt 1
    throw new Error 'One needed, many found'
  return results[0]

subqueries['json-filter'] = executequery

module.exports =
  subqueries: subqueries
  query: executequery
  filter: jsonfilter