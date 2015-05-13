helpers = require 'odoql-utils/helpers'

res =
  binary:
    add: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left + right
    sub: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left - right
    div: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left / right
    mult: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left * right
    mod: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left % right
  unary: {}

binarymath = [
  'pow'
  'atan2'
]
for op in binarymath
  do (op) ->
    operation = Math[op]
    res.binary[op] = (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        operation left, right

uniarymath = [
  'abs'
  'acos'
  'asin'
  'atan'
  'ceil'
  'cos'
  'exp'
  'floor'
  'log'
  'round'
  'sin'
  'sqrt'
  'tan'
]
for op in uniarymath
  do (op) ->
    operation = Math[op]
    res.unary[op] = (exe, params) ->
      helpers.unary exe, params, (source) ->
        operation source

module.exports = res