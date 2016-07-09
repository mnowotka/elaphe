define ['exports', 'core/exceptions', 'lodash'], (exports, Exceptions, _) ->

  class RingInfo
    constructor: ->
      @init = false
      @atomMembers = {}
      @bondMembers = {}
      @atomRings = []
      @bondRings = []

    copy ->
      ret = new RingInfo()
      ret.init = @init
      ret.atomMembers = _.copy @atomMembers
      ret.bondMembers = _.copy @bondMembers
      ret.atomRings = _.copy @atomRings
      ret.bondRings = _.copy @bondRings
      return ret

    initialize: -> @init = true

    isInitialized: -> @init == true

    reset: ->
      if not @init
        return
      @atomMembers = {}
      @bondMembers = {}
      @atomRings = []
      @bondRings = []
      @init = false

    addRing: (atomIndices, bondIndices) ->
      if not @init
        throw new Exceptions.NotInitiatedException()
      if atomIndices.length != bondIndices.length
        throw new Exceptions.IndexMismatchException()
      sz = atomIndices.length
      @atomMembers[idx] = sz for idx in atomIndices
      @bondMembers[idx] = sz for idx in bondIndices
      @atomRings.push(atomIndices)
      @bondRings.push(bondIndices)
      return @atomRings.length

    isAtomInRingOfSize: (idx, size) -> size in @atomMembers[idx]

    numAtomRings: (idx) -> @atomMembers[idx].length

    minAtomRingSize: (idx) -> _.min(_keys(@atomMembers[idx]))

    isBondInRingOfSize: (idx, size) -> size in @bondMembers[idx]

    numBondRings: (idx) -> @bondMembers[idx].length

    minBondRingSize: (idx) -> _.min(_keys(@bondMembers[idx]))

    numRings: -> @atomRings.length

