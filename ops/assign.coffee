async = require 'odo-async'
extend = require 'extend'

module.exports =
  params:
    assign: (exe, params) ->
      getsource = exe.build params.__s
      (callback) ->
        getsource (err, source) ->
          return cb err if err?
          assi = (data, prop, def) -> (cb) ->
            fillrefs = (d, cb) ->
              return cb null, d unless typeof(d) is 'object'
              if d.__q is 'ref'
                getref = exe.build d.__s
                return getref (err, ref) ->
                  return callback err if err?
                  cb null, data[ref]
              tasks = []
              for key, value of d
                do (key, value) ->
                  tasks.push (cb) ->
                    fillrefs value, (err, res) ->
                      d[key] = res
                      cb()
              async.series tasks, ->
                cb null, d
            # copy def
            def = extend yes, {}, def
            fillrefs def, (err, filled) ->
              return callback err if err?
              getref = exe.build filled
              getref (err, value) ->
                return callback err if err?
                data[prop] = value
                cb()
            
          tasks = []
          if source instanceof Array
            for d in source
              for prop, def of params.__p
                tasks.push assi d, prop, def
          else
            for prop, def of params.__p
              tasks.push assi source, prop, def
          
          async.series tasks, ->
            callback null, source