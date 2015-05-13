module.exports =
  binary: (exe, params, callback) ->
    getleft = exe.build params.__l
    getright = exe.build params.__r
    (cb) ->
      getleft (err, left) ->
        return cb err if err?
        getright (err, right) ->
          return cb err if err?
          cb null, callback left, right

  unary: (exe, params, callback) ->
    getsource = exe.build params.__s
    (cb) ->
      getsource (err, source) ->
        return cb err if err?
        cb null, callback source

  params: (exe, params, callback) ->
    getparams = exe.build params.__p
    getsource = exe.build params.__s
    (cb) ->
      getparams (err, params) ->
        return cb err if err?
        getsource (err, source) ->
          return cb err if err?
          cb null, callback params, source