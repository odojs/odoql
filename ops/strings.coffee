helpers = require './helpers'

module.exports =
  params:
    findandreplace: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        if typeof(source) isnt 'string'
          throw new Error 'Expecting string for findandreplace'
        source.replace new RegExp(params.find, params.flags), params.replace
  unary:
    uppercase: (exe, params) ->
      helpers.unary exe, params, (source) ->
        source.toUpperCase()
    lowercase: (exe, params) ->
      helpers.unary exe, params, (source) ->
        source.toLowerCase()
  binary:
    concat: (exe, params) ->
      helpers.binary exe, params, (left, right) ->
        "#{left}#{right}"
  trinary:
    substr: (exe, params) ->
      getparams = exe.build params.__p
      getleft = exe.build params.__l
      getright = exe.build params.__r
      (cb) ->
        getparams (err, params) ->
          return cb err if err?
          getleft (err, left) ->
            return cb err if err?
            getright (err, right) ->
              return cb err if err?
              cb null, params.substr left, right