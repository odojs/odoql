module.exports = (exe, params) ->
  getdata = exe.build params.__source
  (cb) ->
    getdata (err, data) ->
      unless data instanceof Array
        throw new Error 'Not an array'
      if data.length is 0
        return cb null, null
      if data.length is 1
        return cb null, data.pop()
      throw new Error 'More than one item'