eventEmitterClassPath = '../src/vendor/wheaton/event/emitter'

jest.dontMock eventEmitterClassPath

describe 'Wheaton/Event/Emitter', ->

  eventEmitter = undefined

  beforeEach ->
    EventEmitter = require eventEmitterClassPath
    eventEmitter = new EventEmitter
    mockEmit = do jest.genMockFunction
    eventEmitter.emit = mockEmit

  it 'registers an event listener', ->
    numEventListeners = eventEmitter.listenerCount 'jestTestEvent'
    eventEmitter.on 'jestTestEvent', -> return

    expect(eventEmitter.listenerCount 'jestTestEvent')
      .toBeGreaterThan numEventListeners

  it 'removes an event listener', ->
    eventCallback = -> 1337
    eventEmitter.on 'jestTestEvent', eventCallback
    numEventListeners = eventEmitter.listenerCount 'jestTestEvent'
    eventEmitter.off 'jestTestEvent', eventCallback

    expect(eventEmitter.listenerCount 'jestTestEvent')
      .toBeLessThan numEventListeners

  it 'emits event listeners', ->
    eventCallback = -> 1337
    eventEmitter.on 'jestTestEvent', eventCallback
    eventEmitter.emit 'jestTestEvent'

    expect(eventEmitter.emit)
      .toBeCalledWith 'jestTestEvent'

  it 'removes once listeners after emitting', ->
    mockListenerCount = do jest.genMockFunction
    mockListenerCount
      .mockReturnValueOnce 1
      .mockReturnValueOnce 0
    firstMockCall = do mockListenerCount
    secondMockCall = do mockListenerCount
    eventCallback = -> 1337
    eventEmitter.on 'jestTestEvent', eventCallback
    eventEmitter.emit 'jestTestEvent'

    expect(eventEmitter.emit)
      .toBeCalledWith 'jestTestEvent'

    expect(firstMockCall).toBeGreaterThan secondMockCall

  it 'does not add more listeners than maxListeners allows', ->
    eventEmitter.setMaxListeners 1
    eventEmitter.on 'jestTestEvent', -> 1
    eventEmitter.on 'jestTestEvent', -> 2
    eventEmitter.on 'jestTestEvent', -> 3

    expect(eventEmitter.listenerCount 'jestTestEvent').toBe 1
