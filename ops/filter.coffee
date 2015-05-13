helpers = require '../ops/helpers'

module.exports =
  params:
    filter: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        source.filter (d) ->
          for key, test of params
            return no if d[key] is undefined
            if test instanceof Array
              return no unless d[key] in test
            else
              return no if d[key] isnt test
          yes