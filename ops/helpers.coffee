module.exports =
  binary: (exe, params, callback) ->
    getleft = exe.build params.__left
    getright = exe.build params.__right
    (cb) ->
      getleft (err, left) ->
        return cb err if err?
        getright (err, right) ->
          return cb err if err?
          cb null, callback left, right

  unary: (exe, params, callback) ->
    getsource = exe.build params.__source
    (cb) ->
      getsource (err, source) ->
        return cb err if err?
        cb null, callback source

  params: (exe, params, callback) ->
    getparams = exe.build params.__params
    getsource = exe.build params.__source
    (cb) ->
      getparams (err, params) ->
        return cb err if err?
        getsource (err, source) ->
          return cb err if err?
          cb null, callback params, source