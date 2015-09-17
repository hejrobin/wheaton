cardClassPath = '../src/vendor/wheaton/objects/card'

jest.dontMock cardClassPath

describe 'Wheaton/Objects/Card', ->

  card = undefined

  beforeEach ->
    Card = require cardClassPath
    card = new Card
      guid: 'pkmn_pikachu'
      name: 'Pikachu'
      deckLimit: 5
      description: 'Foo'
      instanceOptions:
        onDraw: do jest.genMockFunction
        onPlay: do jest.genMockFunction
        onPalm: do jest.genMockFunction
        onRevive: do jest.genMockFunction
        onDiscard: do jest.genMockFunction

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

  it 'calls onDraw function when drawn', ->
    card.draw()

    expect card.instanceOptions.onDraw
      .toBeCalled()

  it 'decreases in quantity when drawn', ->
    initialQuantity = card.quantity
    card.draw()
    quantityAfterDraw = card.quantity

    expect initialQuantity
      .toBeGreaterThan quantityAfterDraw

  it 'cannot be played if not drawn', ->
    card.play()

    expect card.instanceOptions.onPlay
      .not.toBeCalled()

  it 'calls onPlay when played after it is drawn', ->
    card.draw().play()

    expect card.instanceOptions.onPlay
      .toBeCalled()

  it 'cannot be palmed if not drawn', ->
    card.palm()

    expect card.instanceOptions.onPalm
      .not.toBeCalled()

  it 'calls onPalm when palmed after it is drawn', ->
    card.draw().palm()

    expect card.instanceOptions.onPalm
      .toBeCalled()

  it 'cannot be revived if not discarded', ->
    card.revive()

    expect(card.instanceOptions.onRevive).not.toBeCalled()

  it 'calls onRevive when revived after it is drawn', ->
    card.draw().discard().revive()

    expect card.instanceOptions.onRevive
      .toBeCalled()

  it 'cannot be discarded if already discarded', ->
    card.draw().discard()
    card.options onDiscard: do jest.genMockFunction
    card.draw().discard()

    expect card.instanceOptions.onDiscard
      .not.toBeCalled()

  it 'calls onDiscard when discarded after it is drawn', ->
    card.draw().discard()

    expect card.instanceOptions.onDiscard
      .toBeCalled()
