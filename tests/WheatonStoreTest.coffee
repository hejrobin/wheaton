storeClassPath = '../src/vendor/wheaton/Store'

jest.dontMock storeClassPath

describe 'Store', ->

  store = undefined

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
    Store = require storeClassPath
    store = new Store helloWorldDict

  it 'returns data store with Storage.data getter', ->
    expect helloWorldDict
      .toEqual store.data

  it 'replaces data store with Storage.data setter', ->
    store.data = gothamVillainsDict

    expect helloWorldDict
      .not.toEqual store.data

  it 'returns size of data store with Storage.size', ->
    helloWorldDictSize = Object.keys(helloWorldDict).length

    expect helloWorldDictSize
      .toEqual store.size

  it 'returns only keys from data store with Storage.keys', ->
    helloWorldDictKeys = Object.keys helloWorldDict

    expect helloWorldDictKeys
      .toEqual store.keys

  it 'can shuffle data store keys', ->
    expect store.shuffledKeys
      .not.toEqual store.keys

  it 'returns only values from data store with Storage.values', ->
    gothamVillainsValues = Object.keys(gothamVillainsDict).map (key) -> gothamVillainsDict[key]
    store.replace gothamVillainsDict

    expect gothamVillainsValues
      .toEqual store.values

  it 'returns a random key from data store', ->
    hasRandomKey = store.has store.randomKey

    expect hasRandomKey
      .toBe true

  it 'returns first key from data store with Storage.firstKey', ->
    firstKeyInHelloWorldDict = Object.keys(helloWorldDict)[0]

    expect firstKeyInHelloWorldDict
      .toBe store.firstKey

  it 'returns last key from data store with Storage.lastKey', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    helloWorldDictSize = helloWorldDictKeys.length
    lastKeyInHelloWorldDict = helloWorldDictKeys[helloWorldDictSize - 1]

    expect lastKeyInHelloWorldDict
      .toBe store.lastKey

  it 'returns a random value from data store', ->
    includesRandomValue = store.includes store.random

    expect includesRandomValue
      .toBe true

  it 'returns key from input value', ->
    expect(store.keyOf 'Hello World')
      .toBe 'en'

  it 'returns first value from data store with Storage.first', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    firstKeyInHelloWorldDict = helloWorldDictKeys[0]
    firstValueInHelloWorldDict = helloWorldDict[firstKeyInHelloWorldDict]

    expect firstValueInHelloWorldDict
      .toBe store.first

  it 'returns last key from data store with Storage.last', ->
    helloWorldDictKeys = Object.keys helloWorldDict
    helloWorldDictSize = helloWorldDictKeys.length
    lastKeyInHelloWorldDict = helloWorldDictKeys[helloWorldDictSize - 1]
    lastValueInHelloWorldDict = helloWorldDict[lastKeyInHelloWorldDict]

    expect lastValueInHelloWorldDict
      .toBe store.last

  it 'can check if a key exists', ->
    storeHasKey = store.has 'en'

    expect storeHasKey
      .toBe true

  it 'can check if several keys exists', ->
    storeHasKeys = store.has 'en', 'se', 'jp'

    expect storeHasKeys
      .toBe true

  it 'can check if a value exists', ->
    storeIncludesValue = store.includes 'Hello World'

    expect storeIncludesValue
      .toBe true

  it 'can check if several values exists', ->
    storeIncludesValues = store.includes 'Hello World', 'Hejsan Världen', 'こんにちは世界'

    expect storeIncludesValues
      .toBe true

  it 'returns data based on key', ->
    englishWorldGreet = store.get 'en'

    expect englishWorldGreet
      .not.toBe null

  it 'sets a value based on key', ->
    store.replace gothamVillainsDict
    store.set 'oc', 'Oswald Cobblepot'
    hasSetValue = store.has 'oc'

    expect hasSetValue
      .toBe true

  it 'can check if key and value pair match', ->
    keyValueMatches = store.is 'en', 'Hello World'

    expect keyValueMatches
      .toBe true

  it 'removes and returns data from store using Storage.grab', ->
    store.set 'swedishChef', 'Hellu Vurld'
    grabbedData = store.grab 'swedishChef'
    grabbedDataExistsInStore = store.includes grabbedData

    expect grabbedData
      .toBe 'Hellu Vurld'

    expect grabbedDataExistsInStore
      .toBe false

  it 'destroys store', ->
    emptyObject = {}
    destroyedStorage = do store.destroy

    expect emptyObject
      .toEqual destroyedStorage.data

  it 'returns a query string using Storage.parameterize', ->
    store.replace 'foo': 'Foo', 'bar': 'Bar'
    expectedQueryString = 'foo=Foo&bar=Bar'
    parameterizedStorage = store.parameterized

    expect expectedQueryString
      .toEqual parameterizedStorage

  it 'returns a serialized JSON string using Storage.serialize', ->
    jsonHelloWorldDict = JSON.stringify helloWorldDict
    serializedStorage = store.serialized

    expect jsonHelloWorldDict
      .toEqual serializedStorage
