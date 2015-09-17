Storage                   = require '../data/storage'

class Deck extends Storage

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
