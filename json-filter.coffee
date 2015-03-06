module.exports = (items, filter) ->
  items.filter (item) ->
    for key, test of filter
      return no if item[key] is undefined
      if test instanceof Array
        return no unless item[key] in test
      else
        return no if item[key] isnt test
    yes