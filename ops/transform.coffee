helpers = require '../ops/helpers'

module.exports =
  params:
    findandreplace: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        if typeof(source) isnt 'string'
          throw new Error 'Expecting string for findandreplace'
        source.replace new RegExp(params.find, params.flags), params.replace
    pluck: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        plu = (d) -> d[params]
        if source instanceof Array
          source.map plu
        else
          plu source
    remove: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        rem = (d) ->
          for target, _ of params
            delete d[target]
          d
        if source instanceof Array
          source.map rem
        else
          rem source
    shape: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        sha = (d) ->
          res = {}
          for target, _ of params
            res[target] = d[target]
          res
        if source instanceof Array
          source.map sha
        else
          sha source
    translate: (exe, params) ->
      helpers.params exe, params, (params, source) ->
        trans = (d) ->
          for target, source of params
            value = d[source]
            delete d[source]
            d[target] = value
          d
        if source instanceof Array
          source.map trans
        else
          trans source

    count: (exe, params) ->
      helpers.unary exe, params, (source) ->
        unless source instanceof Array
          throw new Error 'Not an array'
        source.length
    one: (exe, params) ->
      helpers.unary exe, params, (source) ->
        unless source instanceof Array
          throw new Error 'Not an array'
        unless source.length is 1
          throw new Error 'No single item'
        source.pop()
    oneornone: (exe, params) ->
      helpers.unary exe, params, (source) ->
        unless source instanceof Array
          throw new Error 'Not an array'
        if source.length is 0
          return null
        if source.length is 1
          return source.pop()
        throw new Error 'More than one item'