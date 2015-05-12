module.exports = (exe, params) ->
  getparams = exe.build params.__params
  getdata = exe.build params.__source
  (cb) ->
    getparams (err, params) ->
      getdata (err, data) ->
        cb null, data.filter (d) ->
          for key, test of params
            return no if d[key] is undefined
            if test instanceof Array
              return no unless d[key] in test
            else
              return no if d[key] isnt test
          yes