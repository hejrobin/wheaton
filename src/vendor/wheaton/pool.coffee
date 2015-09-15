Emitter                   = require './event/emitter'
Card                      = require './card'
utils                     = require './utils'
{extend, mutable}         = utils
{serialize}               = utils

class Pool extends Emitter

  {get, set} = mutable @::

  _dataStore = []

  get 'store', ->
    _dataStore

  get 'size', ->
    @store.length

  get 'randomKey', ->
    rndm = do Math.random
    keys.length * rndm << 0

  get 'random', ->
    @store[@randomKey]

  get 'first', ->
    @store[0]

  get 'last', ->
    @store[@size - 1]

  includes: (cardObjects...) ->
    cardObjects.map (cardObject) =>
      @store.indexOf cardObject
    .indexOf(-1) is -1

  push: (cardObjects...) ->
    for cardObject in cardObjects
      if cardObject instanceof Card
        @store.push cardObject
        @emit 'push', cardObject
    this

  pop: ->
    cardObject = do @store.pop
    @emit 'pop', cardObject
    cardObject

  grab: (cardObject) ->
    if @includes cardObject
      cardObjectIndex = @store.indexOf cardObject
      @store.splice cardObjectIndex, 1
    cardObject


module.exports = Pool
