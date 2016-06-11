define ['core/periodic_table', 'core/isotopes', 'core/element', 'core/exceptions',
  'lodash'], (PeriodicTable, Isotopes, Elements, Exceptions, _) ->
  Element = Elements.Element
  class Isotope
    constructor: (a,b) ->
      atomicNumber = null
      isotopeIndex = null
      if (_.isString a) and not b
        arr = a.split /(\d+)/
        if arr.length != 3
          throw new Exceptions.FormatException a
        [symbol, idx] = arr
        if symbol not of Elements
          throw new Exceptions.UnrecognisedElementSymbolException symbol
        atomicNumber = Elements[symbol].properties.atomicNumber
        isotopeIndex = _.parseInt(idx)
        if _.isNaN isotopeIndex
          throw new Exceptions.ParsingException(idx, 'Int')
      else if a instanceof Element and _.isInteger b
        atomicNumber = a.properties.atomicNumber
        isotopeIndex = b
      else if (_.isInteger a) and (_.isInteger b)
        atomicNumber = a
        isotopeIndex = b
      else
        throw new Exceptions.IncorrectArgumentTypeException arguments
      @properties = _.find (new Element(atomicNumber).isotopes), (obj) -> obj.number is isotopeIndex

    toString: -> @properties.id

    getElement: -> new Element @properties.atomicNumber