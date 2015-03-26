# Return two queries, ones that match names and others that don't
module.exports = (query, names) ->
  known = {}
  unknown = {}
  for key, value of query
    if value.__query in names
      known[key] = value
    else
      unknown[key] = value
  known: known
  unknown: unknown