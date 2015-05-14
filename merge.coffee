eq = require './eq'

isquery = require './isquery'
isobject = (o) -> typeof(o) is 'object'

notequal = (a, b) ->
  "Could not merge queries #{a} #{b} are not equal"
notsametype = (a, b) ->
  "Could not merge queries #{a} #{b} are not the same type"

merge = (a, b) ->
  aobject = isobject a
  bobject = isobject a
  if aobject isnt bobject
    throw new Error notsametype a, b
  unless aobject
    unless eq a, b
      throw new Error notequal a, b
    return a
  aisquery = isquery a
  bisquery = isquery b
  if aisquery isnt bisquery
    throw new Error notsametype a, b
  akeys = Object.keys a
  bkeys = Object.keys b
  if akeys.length isnt bkeys.length
    throw new Error notequal a, b
  unless aisquery
    for key, value of b
      a[key] = merge value, b[key]
    return a
  if a.__q isnt b.__q
    console.log a
    console.log b
    throw new Error notequal a.__q, b.__q
  if a.__q is 'shape'
    # shapes extend each other
    for key, _ of b.__p
      a.__p[key] = yes
  else if a.__q is 'filter'
    # filters are anded together if not the same
    unless eq a.__p, b.__p
      a.__p =
        __q: 'and'
        __l: a.__p
        __r: b.__p
  else
    # otherwise we merge
    if a.__p? isnt b.__p?
      throw new Error notequal a.__p, b.__p
    if a.__p?
      a.__p = merge a.__p, b.__p
  for key, value of b
    continue if key is '__q' or key is '__p'
    a[key] = merge a[key], value
  return a

module.exports = merge