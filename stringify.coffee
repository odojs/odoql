isquery = require './isquery'

stringify = (indent, query) ->
  if query instanceof Array or typeof(query) isnt 'object'
    return JSON
      .stringify(query, null, 2)
      .split('\n')
      .map((i) -> "#{indent}#{i}")
      .join '\n'
  newindent = "#{indent}  "
  res = []
  unless isquery query
    for key, value of query
      res.push "#{indent}#{key}:"
      res.push stringify newindent, value
  else
    res.push "#{indent}#{query.__q}"
    if query.__s? and not (query.__p? or query.__l? or query.__r?)
      res.push stringify indent, query.__s
    else if query.__p? and query.__s? and not (query.__l? or query.__r?)
      res.push stringify newindent, query.__p
      res.push stringify indent, query.__s
    else
      if query.__p?
        res.push "#{indent}p:"
        res.push stringify newindent, query.__p
      if query.__s?
        res.push "#{indent}s:"
        res.push stringify newindent, query.__s
      if query.__l?
        res.push "#{indent}l:"
        res.push stringify newindent, query.__l
      if query.__r?
        res.push "#{indent}r:"
        res.push stringify newindent, query.__r
  res.join '\n'

module.exports = (query) -> stringify '', query