helpers = require './helpers'

module.exports =
  binary:
    or: (exe, params) ->
      getleft = exe.build params.__l
      getright = exe.build params.__r
      (cb) ->
        getleft (err, left) ->
          return cb err if err?
          return cb null, yes if left is yes
          getright (err, right) ->
            return cb err if err?
            cb null, right
    and: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left and right
    gt: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left > right
    gte: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left >= right
    lt: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left < right
    lte: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left <= right
    eq: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        left is right
  unary:
    not: (exe, params) ->
      helpers.unary exe, params, (source) ->
        not source