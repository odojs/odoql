module.exports =
  trinary:
    if: (exe, params) ->
      getparams = exe.build params.__params
      getleft = exe.build params.__left
      getright = exe.build params.__right
      (cb) ->
        getparams (err, params) ->
          return cb err if err?
          if params
            getleft (err, left) ->
              return cb err if err?
              cb null, left
          else
            getright (err, right) ->
              return cb err if err?
              cb null, right
    unless: (exe, params) ->
      getparams = exe.build params.__params
      getleft = exe.build params.__left
      getright = exe.build params.__right
      (cb) ->
        getparams (err, params) ->
          return cb err if err?
          unless params
            getleft (err, left) ->
              return cb err if err?
              cb null, left
          else
            getright (err, right) ->
              return cb err if err?
              cb null, right