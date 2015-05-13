extend = require 'extend'
async = require 'odoql-utils/async'
visit = require 'odoql-utils/visit'

module.exports =
  params:
    filter: (exe, params) ->
      getsource = exe.build params.__s
      (callback) ->
        getsource (err, source) ->
          return callback err if err?
          unless source instanceof Array
            throw new Error 'Not an array'
          results = []
          tasks = []
          for data, index in source
            do (data, index) ->
              tasks.push (cb) ->
                fillrefs = (node, cb) ->
                  return cb() if !node.__q? or node.__q isnt 'ref'
                  getref = exe.build node.__s
                  getref (err, res) ->
                    throw new Error err if err?
                    cb data[res] ? ''
                # copy def
                def = extend yes, {}, params.__p
                visit def, fillrefs, (filled) ->
                  return callback err if err?
                  getref = exe.build filled
                  getref (err, value) ->
                    return callback err if err?
                    results[index] = value
                    cb()
          async.series tasks, ->
            result = []
            for should, index in results
              result.push source[index] if should
            callback null, result