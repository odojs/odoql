module.exports = (exe, params) ->
  getdata = exe.build params.__source
  (cb) ->
    getdata (err, data) ->
      unless data instanceof Array
        throw new Error 'Not an array'
      cb null, data.length