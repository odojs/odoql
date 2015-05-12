module.exports = (exe, params) ->
  getdata = exe.build params.__source
  (cb) ->
    getdata (err, data) ->
      unless data instanceof Array
        throw new Error 'Not an array'
      unless data.length is 1
        throw new Error 'No single item'
      cb null, data.pop()