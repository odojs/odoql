extend = require 'odoql-utils/extend'
async = require 'odoql-utils/async'
visit = require 'odoql-utils/visit'

module.exports =
  params:
    assign: (exe, params) ->
      getsource = exe.build params.__s
      (callback) ->
        getsource (err, source) ->
          return cb err if err?
          assi = (data, prop, def) -> (fincb) ->
            fillrefs = (node, cb) ->
              return cb() if !node.__q? or node.__q isnt 'ref'
              getref = exe.build node.__s
              getref (err, res) ->
                throw new Error err if err?
                cb data[res] ? null
            # copy def
            def = extend yes, {}, def
            visit def, fillrefs, (filled) ->
              return callback err if err?
              getref = exe.build filled
              getref (err, value) ->
                return callback err if err?
                data[prop] = value
                fincb()
            
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