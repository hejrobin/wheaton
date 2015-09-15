poolClassPath = '../src/vendor/wheaton/pool'
cardClassPath = '../src/vendor/wheaton/card'

jest.dontMock poolClassPath
jest.dontMock cardClassPath

describe 'Wheaton/Pool', ->

  pool = undefined
  Card = undefined

  beforeEach ->
    Pool = require poolClassPath
    Card = require cardClassPath
    pool = new Pool

  it 'increases size when a card is added', ->
    initialPoolSize = pool.size
    pool.push new Card
    poolSizeAfterAddedCard = pool.size

    expect(initialPoolSize)
      .toBeLessThan poolSizeAfterAddedCard

  it 'increases size when adding another card', ->
    firstCard = new Card 'firstCard'
    pool.push firstCard
    poolSizeAfterFirstCard = pool.size
    secondCard = new Card 'secondCard'
    pool.push secondCard
    poolSizeAfterSecondCard = pool.size

    expect(poolSizeAfterSecondCard)
      .toBeGreaterThan poolSizeAfterFirstCard

  it 'contains firstCard and secondCard', ->
    firstCard = new Card 'firstCard'
    secondCard = new Card 'secondCard'
    pool.push firstCard, secondCard
    includesBothCards = pool.includes firstCard, secondCard

    expect(includesBothCards).toBe true

  it 'decreases size when removing last card', ->
    firstCard = new Card 'firstCard'
    secondCard = new Card 'secondCard'
    pool.push firstCard, secondCard
    poolSizeWithBothCards = pool.size
    pool.pop()

    expect(pool.size).toBeLessThan poolSizeWithBothCards

  it 'decreases size when removing a card using Pool.grab', ->
    firstCard = new Card 'firstCard'
    secondCard = new Card 'secondCard'
    thirdCard = new Card 'thirdCard'
    pool.push firstCard, secondCard, thirdCard
    poolSizeBeforeGrab = pool.size
    pool.grab secondCard

    expect(pool.size).toBeLessThan poolSizeBeforeGrab
