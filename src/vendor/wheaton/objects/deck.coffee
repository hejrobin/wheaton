Storage                   = require '../data/storage'

class Deck extends Storage

  add: (cardObject) ->
    @emit 'add', this
    unless @has cardObject.guid
      @set cardObject.guid, cardObject
    do @get(cardObject).add
    @emit 'added'
    this

  draw: ->
    @emit 'draw', this
    cardObjectKey = @lastKey
    cardObject = @get cardObjectKey
    do cardObject.draw
    if cardObject.quantity <= 0
      @remove cardObjectKey
    @emit 'drawn'
    cardObject


module.exports = Deck
