module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        trans = (d) ->
          for target, source of params
            value = d[source]
            delete d[source]
            d[target] = value
          d
        return cb err if err?
        if data instanceof Array
          cb null, data.map trans
        else
          cb null, trans data