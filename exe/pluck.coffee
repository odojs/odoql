# pluck deeper? 'key.key'?
# what about arrays?
module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        plu = (d) -> d[params]
        return cb err if err?
        if data instanceof Array
          cb null, data.map plu
        else
          cb null, plu data