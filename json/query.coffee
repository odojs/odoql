jsonfilter = require './filter'

fillproperty = (data, shape, subqueries) ->
  if shape.__query?
    return subqueries[shape.__query] data, shape, subqueries
  fillproperties data, shape, subqueries

fillproperties = (data, shape, subqueries) ->
  return null if !data? or data is null
  return data if typeof shape isnt 'object'
  result = {}
  for key, subshape of shape
    continue if !data[key]?
    unless subshape instanceof Array
      result[key] = fillproperty data[key], subshape, subqueries
      continue
    unless data[key] instanceof Array
      throw Error 'Expecting array found ' + typeof data
    subshape = subshape[0]
    result[key] = data[key].map (d) -> fillproperty d, subshape, subqueries
  result

# filter, fill and return one or none
executesinglequery = (data, query, subqueries) ->
  results = jsonfilter data, query.__params.filter
  results = results.map (result) ->
    fillproperties result, query.__shape, subqueries
  return null if results.length is 0
  if results.length isnt 1
    throw new Error 'One needed, many found'
  results[0]

executequery = (data, query, subqueries) ->
  unless query.__shape instanceof Array
    return executesinglequery data, query, subqueries
  # if it's an array we return an array
  results = jsonfilter data, query.__params.filter
  results = results.map (result) ->
    fillproperties result, query.__shape[0], subqueries
  results

module.exports = executequery