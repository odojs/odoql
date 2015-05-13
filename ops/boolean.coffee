helpers = require './helpers'

module.exports =
  binary:
    or: (exe, params) ->
      getleft = exe.build params.__left
      getright = exe.build params.__right
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
  unary:
    not: (exe, params) ->
      helpers.unary exe, params, (source) ->
        not source