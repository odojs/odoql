transformops = require './ops/transform'

builtinsources = [
  require './ops/boolean'
  require './ops/conditional'
  require './ops/maths'
  require './ops/transform'
]
builtin =
  params: {}
  unary: {}
  binary: {}
  trinary: {}
for opssource in builtinsources
  for type, optype of opssource
    for name, fn of optype
      builtin[type][name] = fn

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
  for name, _ of transformops.params
    do (name) ->
      res[name] = (params) ->
        _query = ql[name] params, _query
        res
  for name, _ of transformops.unary
    do (name) ->
      res[name] = ->
        _query = ql[name] _query
        res
  for name, _ of transformops.binary
    do (name) ->
      res[name] = (right) ->
        _query = ql[name] _query, right
        res
  for name, _ of transformops.trinary
    do (name) ->
      res[name] = (left, right) ->
        _query = ql[name] _query, left, right
        res
  res

ql.use = (def) ->
  extra = {}
  res = (query) -> ql query, def
  for name, fn of ql
    res[name] = fn
  res.use = (def) ->
    extra[name] = fn for name, fn of def
    res
  res.use def

for name, _ of builtin.params
  do (name) -> ql[name] = (params, source) ->
    __query: name
    __params: params
    __source: source
for name, _ of builtin.unary
  do (name) -> ql[name] = (source) ->
    __query: name
    __source: source
for name, _ of builtin.binary
  do (name) -> ql[name] = (left, right) ->
    __query: name
    __left: left
    __right: right
for name, _ of builtin.trinary
  do (name) -> ql[name] = (params, left, right) ->
    __query: name
    __params: params
    __left: left
    __right: right

ql.desc = require './ql/desc'
ql.merge = require './ql/merge'
ql.split = require './ql/split'
ql.diff = require './ql/diff'
ql.build = require './ql/build'
ql.exec = require './ql/exec'

module.exports = ql