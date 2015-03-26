jsonquery = require './query'

module.exports = (json) ->
  (query, cb) ->
    try
      result = {}
      for key, value of query
        result[key] = jsonquery json, value,
          filter: jsonquery
      cb null, result
    catch e
      cb e
    ->