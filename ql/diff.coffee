jsondiffpatch = require 'jsondiffpatch'

diffisdelete = (diff) ->
  diff instanceof Array and diff.length is 3 and diff[1] is 0 and diff[2] is 0

module.exports = (prev, next) ->
  result = {}
  diff = jsondiffpatch.diff prev, next
  for key, value of diff
    continue if diffisdelete value
    # any changes require a re-query
    result[key] = next[key]
  for key, value of next
    if value?.__fresh?
      result[key] = value
  result