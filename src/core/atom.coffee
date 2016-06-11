define ['core/element', 'core/periodic_table', 'core/isotopes', 'core/exceptions',
  'lodash'], (Elements, PeriodicTable, Isotopes, Exceptions, _) ->
  class Atom
    constructor: (atom) ->
      @atomicNumber = null
      @isotope = null
      @charge = null
      @formalCharge = null
      @hydrogens = null
      @explicitHydrogens = 0
      @stereo = null
      @index = 0
      @radicalElectrons = 0
      @noImplicit = false
      @isAromatic = false
      @chiralTag = null
      @hybrid = null

    setAtomicNum: (atomicNum) ->
      return

    getProps: ->
      return

    getSymbol: ->
      return

    getDegree: ->
      return

    getTotalDegree: ->
      return

    getTotalNumHs: (includeNeighbors) ->
      return

    getTotalValence: ->
      return

    getNumImplicitHs: ->
      return

    getExplicitValence: ->
      return

    getImplicitValence: ->
      return

    getMass: ->
      return

    setIsotope: (what) ->
      null

    getIsotope: ->
      null

    getElement: ->
      return

    invertChirality: ->
      return

    toString: ->
      return