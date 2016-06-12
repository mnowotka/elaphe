define ['exports', 'core/isotope_data', 'core/element', 'core/exceptions',
  'lodash'], (exports, IsotopeData, elements, Exceptions, _) ->
  class Isotope
    constructor: (a,b) ->
      Elements = elements.Elements
      Element = Elements.Element
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
        @atomicSymbol = symbol
        isotopeIndex = _.parseInt(idx)
        if _.isNaN isotopeIndex
          throw new Exceptions.ParsingException(idx, 'Int')
      else if a instanceof Element and _.isInteger b
        atomicNumber = a.properties.atomicNumber
        isotopeIndex = b
        @atomicSymbol = a.properties.symbol
      else if (_.isInteger a) and (_.isInteger b)
        atomicNumber = a
        isotopeIndex = b
        @atomicSymbol = (_.find (_.values Elements), (obj) ->
          obj.properties.atomicNumber is atomicNumber).properties.symbol
      else
        throw new Exceptions.IncorrectArgumentTypeException arguments
      @properties = _.find @getElement().isotopes, (obj) -> obj.number is isotopeIndex

    toString: -> @properties.id

    getElement: -> elements.Elements[@atomicSymbol]

  iso = null

  exports.Isotope = ->
    if not iso
      isotopes = _.map (_.flatten _.values IsotopeData), (el) ->
        ret = {}
        ret[el.id] = new Isotope el.id
        return ret
      iso = _.extend {}, isotopes..., {'Isotope': Isotope}
    return iso