module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        rem = (d) ->
          for target, _ of params
            delete d[target]
          d
        return cb err if err?
        if data instanceof Array
          cb null, data.map rem
        else
          cb null, rem data