define ['exports', 'core/periodic_table', 'core/isotope_data', 'core/isotope', 'core/exceptions',
  'lodash'], (exports, PeriodicTable, IsotopeData, Isotopes, Exceptions, _) ->
  class Element
    constructor: (id) ->
      if _.isInteger id
        if id >= PeriodicTable.atoms.length
          throw new Exceptions.IncorrectElementIndexException id
        @properties = PeriodicTable.atoms[id]
      else if _.isString id
        @properties = _.find PeriodicTable.atoms, (obj) -> obj.symbol is id
      else
        throw new Exceptions.IncorrectArgumentTypeException id
      if @properties
        @isotopes = IsotopeData[@properties.symbol]
      else throw new Exceptions.UnrecognisedElementSymbolException id

    getIsotope: (idx) ->
      Isotopes()[@properties.symbol + idx]

    getMostCommonIsotope: ->
      Isotopes()[@properties.mostCommonIsotope]

    getDefaultValence: ->
      _.first @properties.valences or 0

    getIsotopes: ->
      Isotopes()[i.id] for i in @isotopes
        
    toString: -> @properties.symbol

  elements = _.map PeriodicTable.atoms, (el) ->
    ret = {}
    ret[el.symbol] = new Element el.symbol
    return ret

  elements = _.extend {}, elements..., {'Element': Element}
  exports.Elements = elements


