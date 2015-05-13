helpers = require 'odoql-utils/helpers'

module.exports =
  unary:
    asInt: (exe, params) ->
      helpers.unary exe, params, (source) ->
        parseInt source
    asFloat: (exe, params) ->
      helpers.unary exe, params, (source) ->
        parseFloat source