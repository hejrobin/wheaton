cardClassPath = '../src/vendor/wheaton/objects/card'

jest.dontMock cardClassPath

describe 'Wheaton/Objects/Card', ->

  card = undefined

  beforeEach ->
    Card = require cardClassPath
    Card::emit = do jest.genMockFunction

    card = new Card
      guid: 'pkmn_pikachu'
      name: 'Pikachu'
      deckLimit: 5
      description: 'Foo'

    card
      .on 'add', -> return
      .on 'draw', -> return
      .on 'play', -> return
      .on 'palm', -> return
      .on 'revive', -> return
      .on 'discard', -> return

  it 'has a guid property', ->
    expect card.guid
      .toBeDefined()

  it 'cannot change guid', ->
    initialGuid = card.guid
    card.guid = 'l33t_hax'

    expect initialGuid
      .not.toBe 'l33t_hax'

  it 'has a name property', ->
    expect card.name
      .toBeDefined()

  it 'cannot change name', ->
    initialName = card.name
    card.name = 'Magikarp'

    expect initialName
      .not.toBe 'Magikarp'

  it 'updates card property if defined validation passes', ->
    initialCardDescription = card.description
    card.description = 'Bar'

    expect initialCardDescription
      .not.toBe card.description

  it 'cannot update card property when validation fails', ->
    initialDrawnState = card.drawn
    card.drawn = 'Snorlax'

    expect initialDrawnState
      .not.toBe 'Snorlax'

  it 'emits "drawn" function when drawn', ->
    card.draw()

    expect card.emit
      .toBeCalledWith 'draw', card

  it 'decreases in quantity when drawn', ->
    initialQuantity = card.quantity
    card.draw()
    quantityAfterDraw = card.quantity

    expect initialQuantity
      .toBeGreaterThan quantityAfterDraw

  it 'cannot be played if not drawn', ->
    card.play()

    expect card.emit
      .not.toBeCalled()

  it 'emits "play" when played after it is drawn', ->
    card.draw().play()

    expect card.emit
      .toBeCalledWith 'play', card

  it 'cannot be palmed if not drawn', ->
    card.palm()

    expect card.emit
      .not.toBeCalled()

  it 'emits "palm" when palmed after it is drawn', ->
    card.draw().palm()

    expect card.emit
      .toBeCalledWith 'palm', card

  it 'cannot be revived if not discarded', ->
    card.revive()

    expect card.emit
      .not.toBeCalled

  it 'emits "revive" when revived after it is drawn', ->
    card.draw().discard().revive()

    expect card.emit
      .toBeCalledWith 'revive', card

  it 'cannot be discarded if already discarded', ->
    card.draw().discard()
    card.options onDiscard: do jest.genMockFunction
    card.draw().discard()

    expect card.emit
      .not.toBeCalled

  it 'emits "discard" when discarded after it is drawn', ->
    card.draw().discard()

    expect card.emit
      .toBeCalledWith 'discard', card
