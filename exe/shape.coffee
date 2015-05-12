# shape deeper? what about arrays?
module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        sha = (d) ->
          res = {}
          for target, _ of params
            res[target] = d[target]
          res
        return cb err if err?
        if data instanceof Array
          cb null, data.map sha
        else
          cb null, sha data