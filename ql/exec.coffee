extend = require 'extend'
build = require './build'
async = require 'odoql-utils/async'

module.exports = (query, stores, callback) ->
  query = build query, stores
  errors = []
  tasks = []
  state = {}
  for q in query
    do (q) ->
      tasks.push (cb) -> q.query (err, results) ->
        if err?
          errors.push err
        else
          extend state, results
        cb()
  async.parallel tasks, ->
    if errors.length isnt 0
      return callback errors, state
    return callback null, state