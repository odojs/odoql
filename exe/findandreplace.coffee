module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        if typeof(data) isnt 'string'
          throw new Error 'Expecting string for findandreplace'
        cb null, data.replace new RegExp(params.find, params.flags), params.replace