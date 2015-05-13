async = require 'odo-async'

visit = (node, nodecb, fincb) ->
  # non object types
  if typeof(node) isnt 'object'
    return fincb node
  nodecb node, (replacement) ->
    if replacement?
      return fincb replacement
    tasks = []
    for key, value of node
      do (key, value) ->
        tasks.push (cb) ->
          visit value, nodecb, (replacement) ->
            node[key] = replacement
            cb()
    async.series tasks, -> fincb node

module.exports = visit