extend = require 'extend'
eq = require './eq'

isquery = require './isquery'
isobject = (o) -> typeof(o) is 'object'

notequal = (a, b) ->
  "Could not merge queries #{a} #{b} are not equal"
notsametype = (a, b) ->
  "Could not merge queries #{a} #{b} are not the same type"

canmerge = (a, b) ->
  aobject = isobject a
  bobject = isobject a
  return no if aobject isnt bobject
  return eq a, b unless aobject
  aisquery = isquery a
  bisquery = isquery b
  return no if aisquery isnt bisquery
  return no if Object.keys(a).length isnt Object.keys(b).length
  unless aisquery
    for key, value of b
      return no unless canmerge value, b[key]
  return no if a.__q isnt b.__q
  if a.__q is 'shape'
  else if a.__q is 'filter'
  else
    # otherwise we merge
    return no if a.__p? isnt b.__p?
  for key, value of b
    continue if key is '__q' or key is '__p'
    return no unless canmerge a[key], value
  yes

module.exports = canmerge