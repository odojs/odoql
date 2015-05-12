builtin = [
  'findandreplace'
  'one'
  'oneornone'
  'shape'
  'pluck'
  'remove'
  'filter'
  'translate'
  'count']
ql = (_query, def) ->
  res =
    query: -> _query
    fresh: ->
      _query.__fresh = yes
      res
    clone: -> ql _query, def
  for name, fn of def
    do (fn) ->
      res[name] = (args...) ->
        _query = fn _query, args...
        res
  build = (name) ->
    res[name] = (params) ->
      _query = ql.unit name, params, _query
      res
  build name for name in builtin
  res
ql.unit = (name, params, source) ->
  __query: name
  __params: params
  __source: source
ql.use = (def) ->
  extra = {}
  res = (query) -> ql query, def
  res.unit = ql.unit
  res.use = (def) ->
    extra[name] = fn for name, fn of def
    res
  res.use def

ql.desc = require './ql/desc'
ql.merge = require './ql/merge'
ql.split = require './ql/split'
ql.diff = require './ql/diff'
ql.build = require './ql/build'
ql.exec = require './ql/exec'
module.exports = ql