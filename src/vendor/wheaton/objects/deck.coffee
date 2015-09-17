Storage                   = require '../data/storage'

class Deck extends Storage

  draw: (shuffleAfterDraw = no) ->
    cardObjectKey = @lastKey
    cardObject = @get cardObjectKey
    do cardObject.draw
    if cardObject.quantity <= 0
      @remove cardObjectKey
    do @shuffle if shuffleAfterDraw
    cardObject


module.exports = Deck
