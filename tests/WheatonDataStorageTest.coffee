storageClassPath = '../src/vendor/wheaton/data/storage'

jest.dontMock storageClassPath

describe 'Wheaton/Data/Storage', ->

  storage = undefined

  helloWorldDict =
    'en': 'Hello World'
    'se': 'Hejsan Världen'
    'jp': 'こんにちは世界'
    'de': 'Hallo Welt'
    'es': 'Hola mundo'
    'nl': 'Hello wereld'
    'ru': 'Здравствулте мир'

  gothamVillainsDict =
    'jk': 'The Joker'
    'hq': 'Harley Quinn'
    'en': 'Edward Nigma'

  beforeEach ->
    Storage = require storageClassPath
    storage = new Storage helloWorldDict

  it 'returns data store with Storage.data getter', ->
    expect helloWorldDict
      .toEqual storage.data

  it 'replaces data store with Storage.data setter', ->
    storage.data = gothamVillainsDict

    expect helloWorldDict
      .not.toEqual storage.data

  it 'returns size of data storage with Storage.size', ->
    helloWorldDictSize = Object.keys(helloWorldDict).length

    expect helloWorldDictSize
      .toEqual storage.size

  it 'returns only keys from data storage with Storage.keys', ->
    helloWorldDictKeys = Object.keys helloWorldDict

    expect helloWorldDictKeys
      .toEqual storage.keys

  it 'can shuffle data store keys', ->
    expect storage.shuffledKeys
      .not.toEqual storage.keys

  it 'returns only values from data storage with Storage.values', ->
    gothamVillainsValues = Object.keys(gothamVillainsDict).map (key) -> gothamVillainsDict[key]
    storage.replace gothamVillainsDict

    expect gothamVillainsValues
      .toEqual storage.values

  it 'returns a random key from data store', ->
    hasRandomKey = storage.has storage.randomKey

    expect hasRandomKey
      .toBe true

  it 'returns first key from data store with Storage.firstKey', ->
    firstKeyInHelloWorldDict = Object.keys(helloWorldDict)[0]

    expect firstKeyInHelloWorldDict
      .toBe storage.firstKey

  it 'returns last key from data store with Storage.lastKey', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    helloWorldDictSize = helloWorldDictKeys.length
    lastKeyInHelloWorldDict = helloWorldDictKeys[helloWorldDictSize - 1]

    expect lastKeyInHelloWorldDict
      .toBe storage.lastKey

  it 'returns a random value from data store', ->
    includesRandomValue = storage.includes storage.random

    expect includesRandomValue
      .toBe true

  it 'returns key from input value', ->
    expect(storage.keyOf 'Hello World')
      .toBe 'en'

  it 'returns first value from data store with Storage.first', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    firstKeyInHelloWorldDict = helloWorldDictKeys[0]
    firstValueInHelloWorldDict = helloWorldDict[firstKeyInHelloWorldDict]

    expect firstValueInHelloWorldDict
      .toBe storage.first

  it 'returns last key from data store with Storage.last', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    helloWorldDictSize = helloWorldDictKeys.length
    lastKeyInHelloWorldDict = helloWorldDictKeys[helloWorldDictSize - 1]
    lastValueInHelloWorldDict = helloWorldDict[lastKeyInHelloWorldDict]

    expect lastValueInHelloWorldDict
      .toBe storage.last

  it 'can check if a key exists', ->
    storageHasKey = storage.has 'en'

    expect storageHasKey
      .toBe true

  it 'can check if several keys exists', ->
    storageHasKeys = storage.has 'en', 'se', 'jp'

    expect storageHasKeys
      .toBe true

  it 'can check if a value exists', ->
    storageIncludesValue = storage.includes 'Hello World'

    expect storageIncludesValue
      .toBe true

  it 'can check if several values exists', ->
    storageIncludesValues = storage.includes 'Hello World', 'Hejsan Världen', 'こんにちは世界'

    expect storageIncludesValues
      .toBe true

  it 'returns data based on key', ->
    englishWorldGreet = storage.get 'en'

    expect englishWorldGreet
      .not.toBe null

  it 'sets a value based on key', ->
    storage.replace gothamVillainsDict
    storage.set 'oc', 'Oswald Cobblepot'
    hasSetValue = storage.has 'oc'

    expect hasSetValue
      .toBe true

  it 'can check if key and value pair match', ->
    keyValueMatches = storage.is 'en', 'Hello World'

    expect keyValueMatches
      .toBe true

  it 'removes and returns data from store using Storage.grab', ->
    storage.set 'swedishChef', 'Hellu Vurld'
    grabbedData = storage.grab 'swedishChef'
    grabbedDataExistsInStore = storage.includes grabbedData

    expect grabbedData
      .toBe 'Hellu Vurld'

    expect grabbedDataExistsInStore
      .toBe false

  it 'destroys storage', ->
    emptyObject = {}
    destroyedStorage = do storage.destroy

    expect emptyObject
      .toEqual destroyedStorage.data

  it 'returns a query string using Storage.parameterize', ->
    storage.replace 'foo': 'Foo', 'bar': 'Bar'
    expectedQueryString = 'foo=Foo&bar=Bar'
    parameterizedStorage = storage.parameterized

    expect expectedQueryString
      .toEqual parameterizedStorage

  it 'returns a serialized JSON string using Storage.serialize', ->
    jsonHelloWorldDict = JSON.stringify helloWorldDict
    serializedStorage = storage.serialized

    expect jsonHelloWorldDict
      .toEqual serializedStorage
