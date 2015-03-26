module.exports =
  query: (name, params, shape) ->
    __query: name
    __params: params
    __shape: shape
  freshquery: (name, params, shape) ->
    __query: name
    __params: params
    __shape: shape
    __fresh: yes
  desc: require './ql/desc'
  merge: require './ql/merge'
  split: require './ql/split'
  diff: require './ql/diff'
  build: require './ql/build'
  exec: require './ql/exec'