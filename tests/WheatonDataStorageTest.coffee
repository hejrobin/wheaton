storageClassPath = '../src/vendor/wheaton/data/storage'

jest.dontMock storageClassPath

describe 'Wheaton/Data/Storage', ->

  storage = undefined

  beforeEach ->
    Storage = require storageClassPath
    storage = new Storage
    storage.set 'en', 'Hello World'
    storage.set 'se', 'Hejsan Världen'
    storage.set 'jp', 'こんにちは世界'

  it 'writes new data and retuns self', ->
    expect(storage.set 'nl', 'Hello wereld').toBe storage

  it 'reads and returns existing data', ->
    expect(storage.get 'se').toBe 'Hejsan Världen'

  it 'increases length when data is written', ->
    storage.set 'fr', 'Bonjour monde'

    expect(storage.length).toBe 4

  it 'decreases length when data is removed', ->
    storage.remove 'jp'

    expect(storage.length).toBe 2

  it 'can replace store', ->
    currentStore = storage.store
    nextStore = de: 'Hallo Welt', es: 'Hola mundo'
    storage.replace nextStore

    expect(storage.store).not.toEqual currentStore

  it 'returns serialized JSON string', ->
    expectedJson = JSON.stringify
      'en': 'Hello World'
      'se': 'Hejsan Världen'
      'jp': 'こんにちは世界'

    expect(storage.serialized).toBe expectedJson

  it 'returns a parameterized query string', ->
    expectedQueryString = 'foo=Foo&bar=Bar'
    storage.replace foo: 'Foo', bar: 'Bar'

    expect(storage.parameterized).toBe expectedQueryString

  it 'returns store keys', ->
    expect(storage.keys).toEqual [
      'en'
      'se'
      'jp'
    ]

  it 'returns store values', ->
    expect(storage.values).toEqual [
      'Hello World',
      'Hejsan Världen',
      'こんにちは世界'
    ]
