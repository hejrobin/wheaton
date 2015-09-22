Store                     = require './Store'

class Deck extends Store

  draw: (drawRandom = false) ->
    @emit 'draw', this
    cardObjectKey = if drawRandom is true then @randomKey else @lastKey
    cardObject = @get cardObjectKey
    do cardObject.draw
    if cardObject.quantity <= 0
      @remove cardObjectKey
    @emit 'drawn'
    cardObject


module.exports = Deck
