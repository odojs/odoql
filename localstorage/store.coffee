module.exports = (query, cb) ->
  result = {}
  for key, value of query
    result[key] = JSON.parse localStorage[value.__params]
  cb null, result
  -> clearTimeout handle