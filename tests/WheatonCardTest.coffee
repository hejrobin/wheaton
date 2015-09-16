cardClassPath = '../src/vendor/wheaton/objects/card'

jest.dontMock cardClassPath

describe 'Wheaton/Card', ->

  card = undefined

  beforeEach ->
    Card = require cardClassPath
    card = new Card 'jestTestCard',
      onDraw: do jest.genMockFunction
      onPlay: do jest.genMockFunction
      onPalm: do jest.genMockFunction
      onRevive: do jest.genMockFunction
      onDiscard: do jest.genMockFunction

  it 'calls onDraw function when drawn', ->
    card.draw()

    expect card.instanceOptions.onDraw
      .toBeCalled()

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

  it 'can be serialized', ->
    expectedResult = JSON.stringify
      isDrawn: no
      isPlayed: no
      isPalmed: no
      isDiscarded: no

    expect expectedResult
      .toEqual card.serialized
