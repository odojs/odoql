module.exports = (query) ->
  return '-- no query --' if Object.keys(query).length is 0
  'query\n' + Object.keys query
    .map (prop) ->
      "  #{prop} from #{query[prop].__query}"
    .join '\n'