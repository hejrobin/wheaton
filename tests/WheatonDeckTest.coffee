deckClassPath = '../src/vendor/wheaton/Deck'
cardClassPath = '../src/vendor/wheaton/Card'

jest.dontMock deckClassPath
jest.dontMock cardClassPath

describe 'Wheaton/Objects/Deck', ->

  deck = undefined

  beforeEach ->
    Deck = require deckClassPath
    Card = require cardClassPath
    deck = new Deck

    gothamVillainsDict =
      'jk': 'The Joker'
      'hq': 'Harley Quinn'
      'en': 'Edward Nigma'

    for guid, name of gothamVillainsDict
      deck.set guid, new Card
        guid: guid
        name: name

  it 'can draw a card', ->
    lastCardInDeck = deck.last
    drawnDeckCard = deck.draw()

    expect lastCardInDeck
      .toEqual drawnDeckCard
